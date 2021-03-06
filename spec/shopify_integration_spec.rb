require 'spec_helper'

describe ShopifyIntegration do
  let(:params) { Factories.parameters }

  it "checks root" do
    get '/'
    expect(last_response.status).to eq(200)
  end

  describe '/get_orders' do
    context 'without order' do
      it 'gets orders' do
        message = {
          parameters: params.merge({
            since: "2016-08-11T11:23:05-04:00"
          })
        }.to_json

        VCR.use_cassette('orders/get_orders_without_order') do
          post '/get_orders', message
          expect(last_response.status).to eq(200)
        end
      end
    end

    context 'with orders' do
      it 'gets orders' do
        message = {
          parameters: params.merge({
            since: "2016-08-10T11:23:05-04:00"
          })
        }.to_json

        VCR.use_cassette('orders/get_orders_with_orders') do
          post '/get_orders', message
          expect(json_response[:summary]).to match /orders from Shopify./
          expect(last_response.status).to eq(200)
        end
      end
    end
  end

  describe '/get_products' do
    context 'success' do
      it 'gets products' do
        message = {
          parameters: params
        }.to_json

        VCR.use_cassette('products/get_products') do
          post '/get_products', message
          expect(json_response[:summary]).to match /products from Shopify./
          expect(last_response.status).to eq(200)
        end
      end
    end
  end

  describe '/add_product' do
    let(:product) { Factories.product }

    context 'product not there' do
      it 'imports new product' do
        message = {
          product: product,
          parameters: params
        }.to_json

        VCR.use_cassette('products/add_product') do
          post '/add_product', message
          expect(json_response[:summary]).to match /Product added with Shopify ID of/
          expect(last_response.status).to eq(200)
        end
      end
    end
  end

  describe '/update_product' do
    context 'product there' do
      it 'update product' do
        message = {
          product: {
            shopify_id: '7071063105',
            name: "Update product title"
          },
          parameters: params
        }.to_json

        VCR.use_cassette('products/update_product') do
          post '/update_product', message
          expect(json_response[:summary]).to match /was updated/
          expect(last_response.status).to eq(200)
        end
      end
    end
  end


  describe '/update_variant' do
    context 'success' do
      it 'update variant' do
        message = {
          variant: {
            sku: '100119',
            price: '10000'
          },
          parameters: params
        }.to_json

        VCR.use_cassette('variants/update_variant') do
          post '/update_variant', message
          expect(json_response[:summary]).to match /Update variant of SKU/
          expect(last_response.status).to eq(200)
        end
      end
    end
  end

  describe '/get_inventory' do
    context 'success' do
      it 'gets inventory' do

        message = {
          parameters: params.merge({
            since: '2016-08-17'
          })
        }.to_json

        VCR.use_cassette('inventories/get_inventory') do
          post '/get_inventory', message
          expect(json_response[:summary]).to match /Retrieved inventories/
          expect(last_response.status).to eq(200)
        end
      end
    end
  end

  describe '/set_inventory' do
    context 'success' do
      it 'sets inventory' do
        message = {
          inventory: {
            product_id: '267586', # or sku
            shopify_id: '7333850497',
            quantity: '10'
          },
          parameters: params
        }.to_json

        VCR.use_cassette('inventories/set_inventory') do
          post '/set_inventory', message
          expect(json_response[:summary]).to match /Set inventory of SKU/
          expect(last_response.status).to eq(200)
        end
      end
    end
  end

  describe '/add_shipment' do
    context 'order not there' do
      it 'cannot add shipment' do
        message = {
          shipment: {
            id: '2568917766',
            order_id: '0', # Shopify want the `order_number` not the `order_id`
            status: 'shipped',
            tracking: '01234567890'
          }, 
          parameters: params
        }.to_json

        VCR.use_cassette('shipments/cannot_add_shipment') do
          post '/update_shipment', message

          expect(json_response[:summary]).to match /not found on Shopify/
          expect(last_response.status).to eq(500)
        end
      end
    end

    context 'order there' do
      it 'add shipment' do
        message = {
          shipment: {
            id: '3650270721',
            order_id: '1003', # Shopify want the `order_number` not the `order_id`
            status: 'shipped',
            tracking: '01234567890'
          },
          parameters: params
        }.to_json

        VCR.use_cassette('shipments/add_shipment') do
          post '/add_shipment', message
          expect(json_response[:summary]).to match /with tracking number/
          expect(last_response.status).to eq(200)
        end
      end
    end
  end

  describe '/update_shipment' do
    context 'order not there' do
      it 'cannot update shipment' do
        message = {
          shipment: {
            id: '2568917766',
            order_id: '0', # Shopify want the `order_number` not the `order_id`
            status: 'shipped',
            tracking: '01234567890'
          }, 
          parameters: params
        }.to_json

        VCR.use_cassette('shipments/cannot_update_shipment') do
          post '/update_shipment', message

          expect(json_response[:summary]).to match /not found on Shopify/
          expect(last_response.status).to eq(500)
        end
      end
    end

    context 'order there' do
      it 'update shipment' do
        message = {
          shipment: {
            id: '3601676033',
            order_id: '1002', # Shopify want the `order_number` not the `order_id`
            status: 'shipped',
            tracking: '01234567890'
          }, 
          parameters: params
        }.to_json

        VCR.use_cassette('shipments/update_shipment') do
          post '/update_shipment', message

          expect(json_response[:summary]).to match /with tracking number/
          expect(last_response.status).to eq(200)
        end
      end
    end
  end

  describe '/get_shipments' do
    context 'success' do
      it 'gets shipments' do
        message = {
          parameters: params.merge({
            since: '2016-07-29'
          })
        }.to_json

        VCR.use_cassette('shipments/get_shipments') do
          post '/get_shipments', message
          expect(json_response[:summary]).to match /shipments from Shopify/
          expect(last_response.status).to eq(200)
        end
      end
    end
  end

  describe '/get_customers' do
    context 'success' do
      it 'gets customers' do
        message = {
          parameters: params
        }.to_json

        VCR.use_cassette('customers/get_customers') do
          post '/get_customers', message
          expect(json_response[:summary]).to match /customers from Shopify./
          expect(last_response.status).to eq(200)
        end
      end
    end
  end

  describe '/add_customer' do
    let(:customer) { Factories.customer }

    context 'customer not there' do
      it 'imports new customer' do
        message = {
          customer: customer,
          parameters: params
        }.to_json

        VCR.use_cassette('customers/add_customer') do
          post '/add_customer', message
          expect(json_response[:summary]).to match /Customer with Shopify ID of/
          expect(last_response.status).to eq(200)
        end
      end
    end
  end

  describe '/update_customer' do
    context 'customer there' do
      it 'update customer' do
        message = {
          customer: {
            shopify_id: '3613331713',
            email: 'spree123@example.com'
          }, 
          parameters: params
        }.to_json

        VCR.use_cassette('customers/update_customer') do
          post '/update_customer', message

          expect(json_response[:summary]).to match /was updated/
          expect(last_response.status).to eq(200)
        end
      end
    end
  end
end