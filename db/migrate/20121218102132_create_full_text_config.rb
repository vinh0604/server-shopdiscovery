class CreateFullTextConfig < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE TEXT SEARCH DICTIONARY english_ispell_product(
        TEMPLATE = ispell,
        DictFile = en_US,
        AffFile = en_US,
        StopWords = english
      );

      CREATE TEXT SEARCH DICTIONARY thesaurus_product_en (
        TEMPLATE = thesaurus,
        DictFile = thesaurus_product_en,
        Dictionary = english_stem
      );

      CREATE TEXT SEARCH DICTIONARY simple_product (
        TEMPLATE = pg_catalog.simple,
        STOPWORDS = product
      );

      CREATE TEXT SEARCH DICTIONARY thesaurus_product_vi (
        TEMPLATE = thesaurus,
        DictFile = thesaurus_product_vi,
        Dictionary = simple_product
      );

      CREATE TEXT SEARCH CONFIGURATION public.product ( COPY = pg_catalog.english );

      ALTER TEXT SEARCH CONFIGURATION product
        ALTER MAPPING FOR word, asciiword, asciihword, hword_asciipart
        WITH thesaurus_product_vi, thesaurus_product_en, english_ispell_product, english_stem;
    SQL
  end

  def down
    execute <<-SQL
      DROP TEXT SEARCH CONFIGURATION public.product;
      DROP TEXT SEARCH DICTIONARY thesaurus_product_vi;
      DROP TEXT SEARCH DICTIONARY thesaurus_product_en;
      DROP TEXT SEARCH DICTIONARY simple_product;
      DROP TEXT SEARCH DICTIONARY english_ispell_product;
    SQL
  end
end
