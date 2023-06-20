require 'rails_helper'

RSpec.describe "Plants", type: :request do
  describe "GET /plants" do
    it "returns an array of all plants" do
      Plant.create(name: "Rose", image: "rose.jpg", price: 10)
      Plant.create(name: "Tulip", image: "tulip.jpg", price: 8)

      get '/plants'
      expect(response).to have_http_status(200)

      plants = JSON.parse(response.body)
      expect(plants.size).to eq(2)
      expect(plants[0]["name"]).to eq("Rose")
      expect(plants[1]["name"]).to eq("Tulip")
    end
  end

  describe "GET /plants/:id" do
    it "returns the first plant" do
      plant = Plant.create(name: "Rose", image: "rose.jpg", price: 10)

      get "/plants/#{plant.id}"
      expect(response).to have_http_status(200)

      plant_data = JSON.parse(response.body)
      expect(plant_data["name"]).to eq("Rose")
    end

    it "returns the second plant" do
      Plant.create(name: "Rose", image: "rose.jpg", price: 10)
      plant = Plant.create(name: "Tulip", image: "tulip.jpg", price: 8)

      get "/plants/#{plant.id}"
      expect(response).to have_http_status(200)

      plant_data = JSON.parse(response.body)
      expect(plant_data["name"]).to eq("Tulip")
    end
  end

  describe "POST /plants" do
    it "creates a new plant" do
      plant_params = {
        plant: {
          name: "Sunflower",
          image: "sunflower.jpg",
          price: 12
        }
      }

      post "/plants", params: plant_params
      expect(response).to have_http_status(201)

      plant = Plant.last
      expect(plant.name).to eq("Sunflower")
      expect(plant.image).to eq("sunflower.jpg")
      expect(plant.price).to eq(12)
    end

    it "returns the plant data" do
      plant_params = {
        plant: {
          name: "Sunflower",
          image: "sunflower.jpg",
          price: 12
        }
      }

      post "/plants", params: plant_params
      expect(response).to have_http_status(201)

      plant_data = JSON.parse(response.body)
      expect(plant_data["name"]).to eq("Sunflower")
      expect(plant_data["image"]).to eq("sunflower.jpg")
      expect(plant_data["price"].to_i).to eq(12)
    end

    it "returns a status code of 201 (created)" do
      plant_params = {
        plant: {
          name: "Sunflower",
          image: "sunflower.jpg",
          price: 12
        }
      }

      post "/plants", params: plant_params
      expect(response).to have_http_status(201)
    end
  end
end
