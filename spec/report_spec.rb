require 'spec_helper'

describe EasyPost::Report do
  TYPE = 'shipment'
  describe '#create' do
    it 'creates a report object' do
      report = EasyPost::Report.create(
                                       start_date: Date.today - 30,
                                       end_date: Date.today,
                                       type: TYPE
                                       )
      expect(report.object).to eq 'ShipmentReport'
      expect(['available', 'new']).to include(report.status)
    end
  end

  describe '#retrieve' do
    it 'retrieves a user created report by public_id' do
      report_1 = EasyPost::Report.create(
                                         start_date: Date.today - 30,
                                         end_date: Date.today,
                                         type: TYPE
                                         )
      report_2 = EasyPost::Report.retrieve(type: TYPE, id: report_1.id)

      expect(report_2.id).to eq(report_1.id)
    end
  end

  describe '#all' do
    it 'retrieves all user created reports' do
      report_1 = EasyPost::Report.create(
                                         start_date: Date.today - 25,
                                         end_date: Date.today,
                                         type: TYPE
                                         )

      report_2 = EasyPost::Report.create(
                                         start_date: Date.today - 29,
                                         end_date: Date.today,
                                         type: TYPE
                                         )
      reports = EasyPost::Report.all(type: TYPE)

      expect(reports.count).to eq 2
    end
  end
end
