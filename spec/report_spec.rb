# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Report do
  describe '.create' do
    it 'creates a report' do
      report = described_class.create(
        start_date: Fixture.report_start_date,
        end_date: Fixture.report_end_date,
        type: Fixture.report_type,
      )

      expect(report).to be_an_instance_of(described_class)
      expect(report.id).to match('shprep')
    end

    it 'creates a report with custom columns' do
      report = described_class.create(
        start_date: Fixture.report_start_date,
        end_date: Fixture.report_end_date,
        type: Fixture.report_type,
        columns: ['usps_zone'],
      )

      # verify params by checking URL in cassette
      # can't do any more verification without downloading CSV
      expect(report).to be_an_instance_of(described_class)
    end

    it 'creates a report with custom additional columns' do
      report = described_class.create(
        start_date: Fixture.report_start_date,
        end_date: Fixture.report_end_date,
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
        start_date: Fixture.report_start_date,
        end_date: Fixture.report_end_date,
        type: 'shipment',
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
        type: 'shipment',
        page_size: Fixture.page_size,
      )

      reports_array = reports.reports

      expect(reports_array.count).to be <= Fixture.page_size
      expect(reports.has_more).not_to be_nil
      expect(reports_array).to all(be_an_instance_of(described_class))
    end
  end
end
