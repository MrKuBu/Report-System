--[[

Report System
By Livaco

Don't edit this file if you do not know what your doing. Only edit the configuration
]]--

util.AddNetworkString("report_openuserpanel")
util.AddNetworkString("report_openadminpanel")
util.AddNetworkString("report_nopermerror")
util.AddNetworkString("report_reporthandler")
util.AddNetworkString("report_reports")

reports = {}

net.Receive("report_reporthandler", function(length, ply)

    ReportedPlayer = net.ReadString()
    ReportReason = net.ReadString()

    table.insert(reports, ply:Nick() .. " reported " .. ReportedPlayer .. " for the reason " .. ReportReason)

    local tablejson = util.TableToJSON(reports, false) 
    if not file.IsDir("livaco/reportsystem", "DATA") then

        file.CreateDir("livaco/reportsystem")

    end

    file.Write("livaco/reportsystem/" .. os.date("%m_%d_%Y %I_%M %p") .. ".txt", os.date() .. "\t" .. tablejson)

end)

hook.Add("PlayerSay", "reportsyscmdhandler", function(sender, text, teambool)

	if text == "!report" or text == "!reportplayer" then
		
		net.Start("report_openuserpanel")
		net.Send(sender)

		return ""
		
	end

	if text == "!reportadmin"  then
		
		if sender:IsAdmin() then

			net.Start("report_openadminpanel")
			net.Send(sender)

			net.Start("report_reports")
			net.WriteTable(reports)
			net.Send(sender)

		else

			net.Start("report_nopermerror")
			net.Send(sender)	

		end

	end
	
end)
