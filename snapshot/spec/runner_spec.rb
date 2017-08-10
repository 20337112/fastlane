require 'os'

describe Snapshot do
  describe Snapshot::Runner do
    let(:runner) { Snapshot::Runner.new }
    describe 'Parses embedded SnapshotHelper.swift' do
      it 'finds the current embedded version' do
        allow(FastlaneCore::Helper).to receive(:xcode_at_least?).with("9.0").and_return(true)

        helper_version = runner.version_of_bundled_helper
        expect(helper_version).to match(/^SnapshotHelperVersion \[\d.\d\]$/)
      end
    end
    describe 'Parses embedded SnapshotHelperXcode8.swift' do
      it 'finds the current embedded version' do
        allow(FastlaneCore::Helper).to receive(:xcode_at_least?).with("9.0").and_return(false)

        helper_version = runner.version_of_bundled_helper
        expect(helper_version).to match(/^SnapshotHelperXcode8Version \[\d.\d\]$/)
      end
    end

    describe 'Decides on the number of sims to launch when simultaneously snapshotting' do
      it 'finds that the # of CPUs -1 is the number of sims to launch' do
        sims = Snapshot::ConcurrentSimulatorLauncher.new.default_number_of_simultaneous_simulators
        expect(sims).to eq(OS.cpu_count - 1)
        expect(sims >= 1).to be(true)
      end
    end
  end
end
