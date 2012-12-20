# encoding: UTF-8
class AddGenerateProductTsvectorFunction < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE OR REPLACE FUNCTION generate_product_tsvector() RETURNS integer AS $$
      DECLARE
        category categories%ROWTYPE;
        category_name VARCHAR(255);
        product products%ROWTYPE;
      BEGIN
        FOR product IN SELECT * FROM products LOOP
          SELECT * INTO category FROM categories WHERE id = product.category_id;
          IF category IS NOT NULL AND category.name = 'Khác' THEN
            SELECT * INTO category FROM categories WHERE id = category.parent_id;
          END IF;
          IF category IS NULL THEN
            category_name := '';
          ELSE
            category_name := category.name;
          END IF;
          UPDATE products SET textsearchable = to_tsvector('product',coalesce(replace(name,'-',' '),'') || ' ' || coalesce(category_name,'')) WHERE id = product.id;
        END LOOP;
        RETURN 1;
      END;
      $$ LANGUAGE plpgsql;

      SELECT generate_product_tsvector();

      CREATE INDEX textsearch_idx ON products USING gin(textsearchable);
    SQL
  end

  def down
    execute <<-SQL
      DROP FUNCTION IF EXISTS generate_product_tsvector()
      DROP INDEX IF EXISTS textsearch_idx;
    SQL
  end
end
