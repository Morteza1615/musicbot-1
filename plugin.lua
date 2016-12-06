function sectominn (Sec)
if (tonumber(Sec) == nil) or (tonumber(Sec) == 0) then
return "00:00"
else
Seconds = math.floor(tonumber(Sec))
if Seconds < 1 then Seconds = 1 end
Minutes = math.floor(Seconds / 60)
Seconds = math.floor(Seconds - (Minutes * 60))
if Seconds < 10 then
Seconds = "0"..Seconds
end
if Minutes < 10 then
Minutes = "0"..Minutes
end
return Minutes..':'..Seconds
end
end


function run(msg)
	blocks = load_data("../blocks.json")
	users = load_data("users.json")
	channels = load_data("channels.json")
	userid = tostring(msg.from.id)
	keyboard = {
		{"جستجو🔎"},{"راهنما🤔"},{"تبلیغ و تبادل"},
		}
	
	if msg.chat.type == "channel" then
		return
	elseif msg.chat.type == "supergroup" or msg.chat.type == "group" then
		if not msg.chat.id == admingp then
			return kickme(msg.chat.id)
		end
	end

	if msg.text == "/start" then
		start_txt = "به ربات "..bot.first_name..' خوش آمدید'
		if users[userid] then
			users[userid].username = (msg.from.username or false)
			save_data("users.json", users)
			users[userid].action = 0
			save_data("users.json", users)
			return send_key(msg.from.id, start_txt, keyboard)
		else
			users[userid] = {}
			users[userid].username = (msg.from.username or false)
			users[userid].action = 0
			save_data("users.json", users)
			return send_key(msg.from.id, start_txt, keyboard)
		end
	elseif not users[userid] then
		users[userid] = {}
		users[userid].username = (msg.from.username or false)
		users[userid].action = 0
		save_data("users.json", users)
		return send_key(msg.from.id, start_txt, keyboard)
	elseif msg.text == "درباره ما📋" then
		about_txt = "درباره مامتنش خخخخخخخخ"
		about_key = {
		{
		{text = "تله جک 😜" , url = "https://telegram.me/jokstel"}
		},
		{
		{text = "سازنده" , url = "https://telegram.me/IT_MKH"}
		}
		}
		return send_inline(msg.from.id, about_txt, about_key)
	elseif msg.text == "راهنما" or msg.text == "/help" or msg.text == "راهنما🤔" then
		help_admin = "_Admin Commands:_\n\n".."   *Block a user:*\n     `/block {telegram id}`\n\n".."   *Unblock a user:*\n     `/unblock {telegram id}`\n\n".."   *Block list:*\n     /blocklist\n\n".."   *Send message to all users:*\n     `/sendtoall {message}`\n\n".."   *All users list:*\n     /users"
		help_user = ":D"
		if msg.chat.id == admingp then
			return send_msg(admingp, help_admin, true)
		else
			return send_msg(msg.from.id, help_user, true)
		end
	elseif msg.text == "تبلیغ و تبادل" then
		rdjvn = mem_num("@jokstel")
		i=0
		for k,v in pairs(users) do
			i=i+1
		end
		bstat = i
		text = "نمایش آمار زنده:\n     زمان: "..os.date("%F - %H:%M:%S").."\n     کانال: "..rdjvn.result.."\n     ربات: "..bstat.."\n\n`برای تبادل و درج تبلیغات خود با ما در ارتباط باشید:`"
		return send_inline(msg.from.id, text, {{{text = "ارتباط با مدیر تبلیغات" , url = "https://telegram.me/IT_MKH"}},{{text = "اگر ریپورت هستید برای ارتباط اینجا کلیک کنید" , url = "https://telegram.me/it_mkh_bot"}},{{text = "برای سفارش هر گونه ربات کلیک کنید" , url = "https://telegram.me/it_mkh"}}})
	elseif msg.text:find('/sendtoall') and msg.chat.id == admingp then
		local usertarget = msg.text:input()
		if usertarget then
			send_msg(admingp, "`لطفا منتظر بمانید...`", true)
			i=1
			for k,v in pairs(users) do
				i=i+1
				send_msg(k, usertarget, true)
			end
			return send_msg(admingp, "`پیام شما به "..i.." نفر ارسال شد`", true)
		else
			return send_msg(admingp, "*/sendtoall test*\n`/sendtoall [message]`", true)
		end
	elseif msg.text == "/users" and msg.chat.id == admingp then
		local list = ""
		i=0
		for k,v in pairs(users) do
			i=i+1
			if users[k].username then
				uz = " - @"..users[k].username
			else
				uz = ""
			end
			list = list..i.."- "..k..uz.."\n"
		end
		return send_msg(admingp, "لیست اعضا:\n\n"..list, false)
	elseif msg.text == "/blocklist" and msg.chat.id == admingp then
		local list = ""
		i=0
		for k,v in pairs(blocks) do
			if v then
				i=i+1
				list = list..i.."- "..k.."\n"
			end
		end
		return send_msg(admingp, "بلاک لیست:\n\n"..list, false)
	elseif msg.text:find('/block') and msg.chat.id == admingp then
		local usertarget = msg.text:input()
		if usertarget then
			if tonumber(usertarget) == admingp or tonumber(usertarget) == bot.id then
				return send_msg(admingp, "`نمیتوانید خودتان را بلاک کنید`", true)
			end
			if blocks[tostring(usertarget)] then
				return send_msg(admingp, "`شخص مورد نظر بلاک است`", true)
			end
			blocks[tostring(usertarget)] = true
			save_data("../blocks.json", blocks)
			send_msg(tonumber(usertarget), "`شما بلاک شدید!`", true)
			return send_msg(admingp, "`شخص مورد نظر بلاک شد`", true)
		else
			return send_msg(admingp, "`بعد از این دستور آی دی شخص مورد نظر را با درج یک فاصله وارد کنید`", true)
		end
	elseif msg.text:find('/unblock') and msg.chat.id == admingp then
		local usertarget = msg.text:input()
		if usertarget then
			if blocks[tostring(usertarget)] then
				blocks[tostring(usertarget)] = false
				save_data("../blocks.json", blocks)
				send_msg(tonumber(usertarget), "`شما آنبلاک شدید!`", true)
				return send_msg(admingp, "`شخص مورد نظر آنبلاک شد`", true)
			end
			return send_msg(admingp, "`شخص مورد نظر بلاک نیست`", true)
		else
			return send_msg(admingp, "`بعد از این دستور آی دی شخص مورد نظر را با درج یک فاصله وارد کنید`", true)
		end
	end
	----------------------------music
	if msg.text:match("^/dl(%d+)$")then
    local value = redis:hget('music:'..msg.from.id, msg.text)

    if not value then
      return send_msg(msg.from.id,'آهنگ مورد نظر پیدا نشد.',true)
    else

    local link = redis:hget('music2:'..msg.from.id,msg.text)
    local title = redis:hget('music3:'..msg.from.id,msg.text)
    send_msg(msg.from.id,value..'\n'..link,ok_cb,false)
    --local file = download_to_file(link,title..'.mp3')
   --send_audio(get_receiver(msg), file, ok_cb, false)
    return 
    end
    return
  end
	--------end

	if msg.text == 'جستجو🔎' then
		key = {
			{"بازگشت🔙"}
		}
		redis:set("user:"..msg.from.id,"start")
		return send_key(msg.from.id,"`لطفا نام ترانه یا خواننده را وارد کنید`",key,true)
		end
	local r = redis:get("user:"..msg.from.id)
	if r == "start" then
		if msg.text == 'بازگشت🔙' then
		redis:del("user:"..msg.from.id)
		return send_key(msg.from.id, start_txt, keyboard)
	end
  local urll = http.request("http://api.gpmod.ir/music.search/?v=2&q="..url.escape(msg.text).."&count=30")
  local jdat = jsonn:decode(urll)
  local textt , time , num = ''
  local hash = 'music:'..msg.from.id
  local hash2 = 'music2:'..msg.from.id
  local hash3 = 'music3:'..msg.from.id
	redis:del(hash)
		if #jdat.response < 1 then return send_msg(msg.from.id,"`ترانه یافت نشد`",true) end
		for i = 1, #jdat.response do
			timee = sectominn(jdat.response[i].duration / 1000)
			textt = textt..'🎧 '..jdat.response[i].title..'\n 🕒'..timee..'\nدانلود : /dl'..i..'\n\n'
      redis:hset(hash, "/dl"..i,'عنوان : `'..jdat.response[i].title..'`\n 🕒 '..timee)
      redis:hset(hash2, "/dl"..i,jdat.response[i].link)
      redis:hset(hash3, "/dl"..i,jdat.response[i].title)

    end
		
  return send_key(msg.from.id, textt, k)
		end

	-------------------------music
	if msg.chat.id == admingp then
		return
	end
	end


function inline(msg)
	tab1 = '{"type":"article","parse_mode":"Markdown","disable_web_page_preview":true,"id":'
	thumb = "http://irapi.ir/icons/"
	if msg.query == "" or msg.query == nil then
		tab_inline = tab1..'"1","title":"جستجو کنید","description":"نام ترانه یا بخضی از اهنگ یا نام خواننده را وارد کنید","message_text":"-__-","thumb_url":"'..thumb..'1.png"}'
	else	
local urll = http.request("http://api.gpmod.ir/music.search/?v=2&q="..url.escape(msg.text).."&count=30")
  local jdat = jsonn:decode(urll)
  local textt , time , num = ''
		if not #jdat.response < 1 then
		for i = 1, #jdat.response do
			timee = sectominn(jdat.response[i].duration / 1000)
			textt = textt..'🎧 '..jdat.response[i].title..'\n 🕒'..timee..'\n[لینک دانلود]('..jdat.response[i].link..')'
			end
			tab_inline = tab1..'"2","title":"مشاهده نتایج","description":"جهت مشاهده نتایج کلیک کنید","message_text":"'..textt..'","thumb_url":"'..thumb..'1.png","reply_markup":{"inline_keyboard":['..tabless..']}}'
		else
			tab_inline = tab1..'"3","title":"@JOKSTEL","description":"موسیقی یافت نشد","message_text":"جهت جستجوی موسیقی و دریافت راهنما به ربات مراحعه کنید","thumb_url":"'..thumb..'2.png"}'
		end
	return send_req(send_api.."/answerInlineQuery?inline_query_id="..msg.id.."&is_personal=true&cache_time=1&results="..url.escape('['..tab_inline..']'))
	
		end
	end
return {launch = run , inline = inline}