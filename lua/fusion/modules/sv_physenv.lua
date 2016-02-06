hook.Add("InitPostEntity", "physenv", function()
	Settings = {}
	Settings.MaxVelocity = 60000
	Settings.MaxAngularVelocity = 60000	

	physenv.SetPerformanceSettings(Settings)
end)

Settings = {}
Settings.MaxVelocity = 60000
Settings.MaxAngularVelocity = 60000	

physenv.SetPerformanceSettings(Settings)