
#require_relative '../aspects/TimingAspect.rb'

#require_relative "../algorithms/reports/MinHistoricCurrentQuoteDifferenceReport.rb"

#TimingAspect.apply(::Reports::MinHistoricCurrentQuoteDifferenceReport)
#reporter = ::Reports::MinHistoricCurrentQuoteDifferenceReport.new

#reporter.run
    




require_relative '../aspects/TimingAspect.rb'

require_relative "../algorithms/reports/MaxDrop.rb"

TimingAspect.apply(::Reports::MaxDrop)
reporter = ::Reports::MaxDrop.new

reporter.run
    