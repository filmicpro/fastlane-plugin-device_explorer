describe Fastlane::Actions::DeviceExplorerAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The device_explorer plugin is working!")

      Fastlane::Actions::DeviceExplorerAction.run(nil)
    end
  end
end
