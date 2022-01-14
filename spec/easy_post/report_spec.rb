# frozen_string_literal: true

require 'spec_helper'

TYPE = 'shipment'

describe EasyPost::Report do
  describe '#create' do
    it 'creates a report object' do
      report = described_class.create(
        start_date: Date.today - 30,
        end_date: Date.today,
        type: TYPE,
      )
      expect(report.object).to eq 'ShipmentReport'
      expect(report.status).to eq('available').or eq('new')
    end
  end

  describe '#retrieve' do
    it 'retrieves a user created report by public_id as a hash' do
      report1 = described_class.create(
        start_date: Date.today - 30,
        end_date: Date.today,
        type: TYPE,
      )
      report2 = described_class.retrieve(id: report1.id)

      expect(report2.id).to eq(report1.id)
    end

    it 'retrieves a user created report by public_id as a string' do
      report1 = described_class.create(
        start_date: Date.today - 30,
        end_date: Date.today,
        type: TYPE,
      )
      report2 = described_class.retrieve(report1.id)

      expect(report2.id).to eq(report1.id)
    end
  end

  describe '#all' do
    it 'retrieves all user created reports' do
      described_class.create(
        start_date: Date.today - 25,
        end_date: Date.today,
        type: TYPE,
      )

      described_class.create(
        start_date: Date.today - 29,
        end_date: Date.today,
        type: TYPE,
      )
      reports = described_class.all(type: TYPE)

      expect(reports.count).to eq 2
    end
  end
end
