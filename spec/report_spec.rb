# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Report do
  describe '.create' do
    it 'creates a report' do
      report = described_class.create(
        start_date: Fixture.report_date,
        end_date: Fixture.report_date,
        type: Fixture.report_type,
      )

      expect(report).to be_an_instance_of(described_class)
      expect(report.id).to match('shprep')
    end

    it 'creates a report with custom columns' do
      report = described_class.create(
        start_date: Fixture.report_date,
        end_date: Fixture.report_date,
        type: Fixture.report_type,
        columns: ['usps_zone'],
      )

      # verify params by checking URL in cassette
      # can't do any more verification without downloading CSV
      expect(report).to be_an_instance_of(described_class)
    end

    it 'creates a report with custom additional columns' do
      report = described_class.create(
        start_date: Fixture.report_date,
        end_date: Fixture.report_date,
        type: Fixture.report_type,
        additional_columns: %w[from_name from_company],
      )

      # verify params by checking URL in cassette
      # can't do any more verification without downloading CSV
      expect(report).to be_an_instance_of(described_class)
    end
  end

  describe '.retrieve' do
    it 'retrieves a report' do
      report = described_class.create(
        start_date: Fixture.report_date,
        end_date: Fixture.report_date,
        type: Fixture.report_type,
      )

      retrieved_report = described_class.retrieve(report.id)

      expect(retrieved_report).to be_an_instance_of(described_class)
      expect(retrieved_report.start_date).to eq(report.start_date)
      expect(retrieved_report.end_date).to eq(report.end_date)
    end
  end

  describe '.all' do
    it 'retrieves all reports' do
      reports = described_class.all(
        type: Fixture.report_type,
        page_size: Fixture.page_size,
      )

      reports_array = reports.reports

      expect(reports_array.count).to be <= Fixture.page_size
      expect(reports.has_more).not_to be_nil
      expect(reports_array).to all(be_an_instance_of(described_class))
    end
  end

  describe '.get_next_page' do
    it 'retrieves the next page of a collection' do
      first_page = described_class.all(
        type: Fixture.report_type,
        page_size: Fixture.page_size,
      )

      begin
        next_page = described_class.get_next_page(first_page)

        first_page_first_id = first_page.reports.first.id
        next_page_first_id = next_page.reports.first.id

        # Did we actually get a new page?
        expect(first_page_first_id).not_to eq(next_page_first_id)
      rescue EasyPost::Error => e
        # If we get an error, make sure it's because there are no more pages.
        expect(e.message).to eq('There are no more pages to retrieve.')
      end
    end

    it 'reuses the params used to retrieve the first page' do
      type = Fixture.report_type

      first_page = described_class.all(
        page_size: Fixture.page_size,
        type: type,
      )

      next_page_params = described_class.build_next_page_params(first_page, first_page.reports, 0)

      expect(next_page_params[:type]).to eq(type)
    end
  end
end
