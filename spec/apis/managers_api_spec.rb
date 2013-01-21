require 'spec_helper'

describe "Managers" do
  describe "GET /api/v1/managers" do
    it "returns status 200 with shop managers"
    it "returns status 500 if shop not found"
  end

  describe "POST /api/v1/managers" do
    it "returns status 201 if success"
    it "returns status 401 if authentication failed"
    it "returns status 401 if user is not shop owner"
  end

  describe "DELETE /api/v1/managers/:id" do
    it "returns status 200 if success"
    it "returns status 401 if authentication failed"
    it "returns status 401 if user is not shop owner"
  end
end