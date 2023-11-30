# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Services::Report do
  let(:client) { EasyPost::Client.new(api_key: ENV['EASYPOST_TEST_API_KEY']) }

  describe '.create' do
    it 'creates a report' do
      report = client.report.create(
        start_date: Fixture.report_date,
        end_date: Fixture.report_date,
        type: Fixture.report_type,
      )

      expect(report).to be_an_instance_of(EasyPost::Models::Report)
      expect(report.id).to match('shprep')
    end

    it 'creates a report with custom columns' do
      report = client.report.create(
        start_date: Fixture.report_date,
        end_date: Fixture.report_date,
        type: Fixture.report_type,
        columns: ['usps_zone'],
      )

      # verify params by checking URL in cassette
      # can't do any more verification without downloading CSV
      expect(report).to be_an_instance_of(EasyPost::Models::Report)
    end

    it 'creates a report with custom additional columns' do
      report = client.report.create(
        start_date: Fixture.report_date,
        end_date: Fixture.report_date,
        type: Fixture.report_type,
        additional_columns: %w[from_name from_company],
      )

      # verify params by checking URL in cassette
      # can't do any more verification without downloading CSV
      expect(report).to be_an_instance_of(EasyPost::Models::Report)
    end
  end

  describe '.retrieve' do
    it 'retrieves a report' do
      report = client.report.create(
        start_date: Fixture.report_date,
        end_date: Fixture.report_date,
        type: Fixture.report_type,
      )

      retrieved_report = client.report.retrieve(report.id)

      expect(retrieved_report).to be_an_instance_of(EasyPost::Models::Report)
      expect(retrieved_report.start_date).to eq(report.start_date)
      expect(retrieved_report.end_date).to eq(report.end_date)
    end
  end

  describe '.all' do
    it 'retrieves all reports' do
      reports = client.report.all(
        type: Fixture.report_type,
        page_size: Fixture.page_size,
      )
      expect(reports[EasyPost::InternalUtilities::Constants::FILTERS_KEY]).to be_a(Hash)
      expect(reports[:_filters][:type]).to eq(Fixture.report_type)

      reports_array = reports.reports

      expect(reports_array.count).to be <= Fixture.page_size
      expect(reports.has_more).not_to be_nil
      expect(reports_array).to all(be_an_instance_of(EasyPost::Models::Report))
    end
  end

  describe '.get_next_page' do
    it 'retrieves the next page of a collection' do
      first_page = client.report.all(
        type: Fixture.report_type,
        page_size: Fixture.page_size,
      )

      begin
        next_page = client.report.get_next_page(first_page)

        first_page_first_id = first_page.reports.first.id
        next_page_first_id = next_page.reports.first.id

        # Did we actually get a new page?
        expect(first_page_first_id).not_to eq(next_page_first_id)
        expect(first_page[EasyPost::InternalUtilities::Constants::FILTERS_KEY]).to eq(
          next_page[EasyPost::InternalUtilities::Constants::FILTERS_KEY],
        )
        expect(first_page[:_filters][:type]).to eq(next_page[:_filters][:type])
      rescue EasyPost::Errors::EndOfPaginationError => e
        # If we get an error, make sure it's because there are no more pages.
        expect(e.message).to eq(EasyPost::Constants::NO_MORE_PAGES)
      end
    end
  end
end
