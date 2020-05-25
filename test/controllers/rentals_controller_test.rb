require "test_helper"

describe RentalsController do

  def check_response(expected_type:, expected_status: :success)
    must_respond_with expected_status
    expect(response.header['Content-Type']).must_include 'json'

    body = JSON.parse(response.body)
    expect(body).must_be_kind_of expected_type
    return body
  end

  describe 'check_out' do
    it "creates a new rental due one week from today" do
      customer = Customer.first
      customer_id = customer.id
      customer_original_count = customer.videos_checked_out_count
      video_id = Video.first.id
      rental_data = {
        customer_id: customer_id,
        video_id: video_id
      }

      expect {
        post check_out_path, params: rental_data
      }.must_differ "Rental.count", 1

      body = check_response(expected_type: Hash, expected_status: :created)
      expect(body.keys).must_equal ["id", "customer_id", "video_id", "due_date", "videos_checked_out_count"]

      new_rental = Rental.find_by(customer_id: customer_id)
      expect(new_rental.customer_id).must_equal customer_id
      expect(new_rental.video_id).must_equal video_id
      expect(new_rental.due_date).must_equal ((Date.today + 7).to_s)
      customer.reload
      expect(customer.videos_checked_out_count).must_equal (customer_original_count + 1)
    end

    it "gives an error with invalid customer_id" do
      
    end

    it "gives an error with invalid video_id" do
      
    end
  end

end
