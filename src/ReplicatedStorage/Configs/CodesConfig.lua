local CodesConfig = {}

CodesConfig.Config = {
	Test = 1000,
	RELEASE = 10000
}

function CodesConfig.IsCodeUsed(data, code: string)
	return data.Codes[code]
end

return CodesConfig
