require 'spec_helper'

describe EasyPost::Report do
  [:shipment, :tracker, :payment_log].each do |report_type|
    context "report" do
      let(:type) { report_type }
      let(:type_name) {
        case type
        when :shipment
          "ShipmentReport"
        when :tracker
          "TrackerReport"
        when :payment_log
          "PaymentLogReport"
        else
          raise "Invalid type!"
        end
      }

      describe '#create' do
        it 'creates a report object' do
          report = EasyPost::Report.create(
                                           start_date: Date.today - 30,
                                           end_date: Date.today,
                                           type: type
                                           )
          expect(report.object).to eq type_name
          # will switch that test on when tracker status is deployed
          # expect(report.status).to eq 'available'
        end
      end

      describe '#retrieve' do
        it 'retrieves a user created report by public_id' do
          report_1 = EasyPost::Report.create(
                                             start_date: Date.today - 30,
                                             end_date: Date.today,
                                             type: type
                                             )
          report_2 = EasyPost::Report.retrieve(id: report_1.id)

          expect(report_1.object).to eq type_name
          expect(report_2.object).to eq type_name
          expect(report_2.id).to eq(report_1.id)
        end
      end

      describe '#all' do
        it 'retrieves all user created reports' do
          report_1 = EasyPost::Report.create(
                                             start_date: Date.today - 25,
                                             end_date: Date.today,
                                             type: type
                                             )

          report_2 = EasyPost::Report.create(
                                             start_date: Date.today - 29,
                                             end_date: Date.today,
                                             type: type
                                             )
          reports = EasyPost::Report.all(type: type)

          expect(reports.count).to eq 2
        end
      end
    end
  end

  it 'fails to create a report object' do
    expect { EasyPost::Report.create(
      start_date: Date.today - 30,
      end_date: Date.today,
      type: 'foobar'
      ) }.to raise_exception(EasyPost::Error)
  end
end
