# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Report do
  describe '.create' do
    it 'creates a payment_log report' do
      report = described_class.create(
        start_date: Fixture.report_start_date,
        end_date: Fixture.report_end_date,
        type: 'payment_log',
      )

      expect(report).to be_an_instance_of(described_class)
      expect(report.id).to match('plrep')
    end

    it 'creates a refund report' do
      report = described_class.create(
        start_date: Fixture.report_start_date,
        end_date: Fixture.report_end_date,
        type: 'refund',
      )

      expect(report).to be_an_instance_of(described_class)
      expect(report.id).to match('refrep')
    end

    it 'creates a shipment report' do
      report = described_class.create(
        start_date: Fixture.report_start_date,
        end_date: Fixture.report_end_date,
        type: 'shipment',
      )

      expect(report).to be_an_instance_of(described_class)
      expect(report.id).to match('shprep')
    end

    it 'creates a shipment_invoice report' do
      report = described_class.create(
        start_date: Fixture.report_start_date,
        end_date: Fixture.report_end_date,
        type: 'shipment_invoice',
      )

      expect(report).to be_an_instance_of(described_class)
      expect(report.id).to match('shpinvrep')
    end

    it 'creates a tracker report' do
      report = described_class.create(
        start_date: Fixture.report_start_date,
        end_date: Fixture.report_end_date,
        type: 'tracker',
      )

      expect(report).to be_an_instance_of(described_class)
      expect(report.id).to match('trkrep')
    end

    it 'creates a report with custom columns' do
      report = described_class.create(
        start_date: Fixture.report_start_date,
        end_date: Fixture.report_end_date,
        type: 'shipment',
        columns: ['usps_zone'],
      )

      expect(report).to be_an_instance_of(described_class)
      # verify params by checking URL in cassette
      # can't do any more verification without downloading CSV
    end

    it 'creates a report with custom additional columns' do
      report = described_class.create(
        start_date: Fixture.report_start_date,
        end_date: Fixture.report_end_date,
        type: 'shipment',
        additional_columns: %w[from_name from_company],
      )

      expect(report).to be_an_instance_of(described_class)
      # verify params by checking URL in cassette
      # can't do any more verification without downloading CSV
    end

  end

  describe '.retrieve' do
    it 'retrieves a payment_log report' do
      report = described_class.create(
        start_date: Fixture.report_start_date,
        end_date: Fixture.report_end_date,
        type: 'payment_log',
      )

      retrieved_report = described_class.retrieve(report.id)

      expect(retrieved_report).to be_an_instance_of(described_class)
      expect(retrieved_report.start_date).to eq(report.start_date)
      expect(retrieved_report.end_date).to eq(report.end_date)
    end

    it 'retrieves a refund report' do
      report = described_class.create(
        start_date: Fixture.report_start_date,
        end_date: Fixture.report_end_date,
        type: 'refund',
      )

      retrieved_report = described_class.retrieve(report.id)

      expect(retrieved_report).to be_an_instance_of(described_class)
      expect(retrieved_report.start_date).to eq(report.start_date)
      expect(retrieved_report.end_date).to eq(report.end_date)
    end

    it 'retrieves a shipment report' do
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

    it 'retrieves a shipment_invoice report' do
      report = described_class.create(
        start_date: Fixture.report_start_date,
        end_date: Fixture.report_end_date,
        type: 'shipment_invoice',
      )

      retrieved_report = described_class.retrieve(report.id)

      expect(retrieved_report).to be_an_instance_of(described_class)
      expect(retrieved_report.start_date).to eq(report.start_date)
      expect(retrieved_report.end_date).to eq(report.end_date)
    end

    it 'retrieves a tracker report' do
      report = described_class.create(
        start_date: Fixture.report_start_date,
        end_date: Fixture.report_end_date,
        type: 'tracker',
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
