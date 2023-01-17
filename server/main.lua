--[[
Copyright © 2023 Mycroft (Kasey Fitton)

All rights reserved.

Permission is hereby granted, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software with 'All rights reserved'. Even if 'All rights reserved' is very clear :

  You shall not sell and/or resell this software
  You Can use and Modify this software
  You Shall Not Distribute and/or Redistribute the software
  The above copyright notice and this permission notice shall be included in all copies and files of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

]]
local Object = Config.Framework.Server.getObject()

Config.Framework.Server.BuyTicketCallback(Object)

RegisterNetEvent("cinema:exit", function(cinema)
    local source = source
    SetPlayerRoutingBucket(source, 0)
end)
