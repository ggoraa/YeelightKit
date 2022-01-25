//
//  DeviceProperty.swift
//  
//
//  Created by Егор Яковенко on 22.12.2021.
//

/// An enum for representing device properties. Used in ``YeelightKit/YeelightKit/get(properties:of:)`` function, to get individual properties of a device.
public enum DeviceProperty: String {
	case isOn = "power"
	case brightness = "bright"
	case colorTemperature = "ct"
	case rgbColor = "rgb"
	case hue
	case saturation = "sat"
	case colorMode = "color_mode"
	/// Is the flow mode running.
	case isFlowing = "flowing"
	case isMusicModeOn = "music_on"
	case name
	case isBackgroundOn = "bg_power"
	/// Is the flow mode running on background light.
	case isBackgroundFlowing = "bg_flowing"
	case backgroundColorTemperature = "bg_ct"
	case backgroundColorMode = "bg_lmode"
	case backgroundBrightness = "bg_bright"
	case backgroundRgbColor = "bg_rgb"
	case backgroundHue = "bg_hue"
	case backgroundSaturation = "bg_sat"
	case nightLightBrightness = "nl_br"
	/// Only applicable for the ceiling light.
	case activeMode = "active_mode"
}
