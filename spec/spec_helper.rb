require "rubygems"
require "appium_lib"

# テスト対象がiOS/Androidか判定
#
# @return [true,false] iOSならtrue、Androidならfalse
def ios?
  return @platform_name == "iOS"
end

@platform_name = ENV['DEVICEFARM_DEVICE_PLATFORM_NAME']
@device_name = ENV['DEVICEFARM_DEVICE_NAME']
@app_path = ENV['DEVICEFARM_APP_PATH']
@udid = ENV['DEVICEFARM_DEVICE_UDID']

caps = {
  caps: {
    "platformName": @platform_name,
    "udid": @udid,
    "deviceName": @device_name,
    "automationName": ios? ? 'XCUITest' : 'UiAutomator2',
    "app": @app_path
  },
  appium_lib: {
    wait: 10
  }
}

RSpec.configure { |c|
  c.before(:each) {
    @driver = Appium::Driver.new(caps, true)
    @driver.start_driver
    @driver.manage.timeouts.implicit_wait = 30
    Appium.promote_appium_methods Object
  }

  c.after(:each) {
    @driver.driver_quit
  }
}
