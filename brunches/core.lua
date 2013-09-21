namespace"trit"{
	namespace"spine"{
		class "WindowManager"{
			metamethod"_init"
			:body(
				function(self)
					self.tabWindows = {};
				end
			);
			
			method"AddWindow"
			:body(
				function(self,windowClass, strTitle, width, height)
					local i = table.getn(self.tabWindows)+1
					self.tabWindows[i] = windowClass:new(strTitle);
					self.tabWindows[i]:swCreate(width, height);
					self.tabWindows[i]:Init();
				end
			);
			
			
			method"GetWindows"
			:body(
				function(self)
					return table.getn(self.tabWindows);
				end
			);
			
			method"GetHanWindow"
			:body(
				function(self,i)
					return self.tabWindows[i]:swGetHanWindow()
				end
			);
			
			method"GetHanScreen"
			:body(
				function(self,i)
					return self.tabWindows[i]:swGetHanScreen()
				end
			);

			metamethod"__call"
			:body(
				function(self)
					for i = 1, table.getn(self.tabWindows) do
						self.tabWindows[i]();
					end
				end
			);
		};
		
		class "Commander"
		:inherits(trit.graphics.SmirnoffWindow)
		{
			method"Init"
			:attributes(override)
			:body(
				function(self)
					self.maxLines = 100;
					self.lineHeight = 15
					self.tabMessageLog = {}
					
					self:swSetBackground(hsv(0,0,0.2))
					
					self.key = trit.input.Keyboard:new()
					
				end
			);
			
			method"Call"
			:attributes(override)
			:body(
				function(self)
					self.key:SetCondition(self:swIsWindowActive())
					
					--self:Out(self:swIsWindowActive())
					--self:Out(self.key:Key("!"))
					--self:Out(tostring(string.byte("`")).." "..tostring(self.key:Key("`")))
				end
			);
			
			method"Out"
			:body(
				function(self,data)
					local str = tostring(data);
					local strBuffer
					
					--文字列中に改行が含まれない場合
					if string.find(str, "\n") == nil then
						table.insert(self.tabMessageLog, 1, str);
						if table.getn(self.tabMessageLog)>self.maxLines then
							table.remove(self.tabMessageLog)
						end
					else					
						--文字列中に改行が含まれる場合
						while string.find(str, "\n") ~= nil do
							local header, footer = string.find(str, "\n")
							--次に処理する文字列(改行より後)をBufferに格納
							strBuffer = string.sub(str, footer+1)
							--表示文字列の切り出し
							str = string.sub(str, 1, header-1)
							
							table.insert(self.tabMessageLog, 1, str);
							if table.getn(self.tabMessageLog)>self.maxLines then
								table.remove(self.tabMessageLog)
							end
							
							--strにBufferを代入
							str = strBuffer
						end
						
						--最後の\nより後に文字列がある場合の処理
						if str ~= nil then
							table.insert(self.tabMessageLog, 1, str);
							if table.getn(self.tabMessageLog)>self.maxLines then
								table.remove(self.tabMessageLog)
							end
						end

					end
				end
			);
			
			method"In"
			:body(
				function(self,data)
					
				end
			);
			
			
			
			
			method"Draw"
			:attributes(override)
			:body(
				function(self)
					self:swSetColor(hsv(0,0,1))
					for i = 1, self.maxLines do
						if self.tabMessageLog[i] ~= nil then
							self.swFont(2,self.swHeight-(i+1)*self.lineHeight,tostring(self.tabMessageLog[i]))
						end
					end
					
					self.swBrush:SetColor(hsv(0,0,0.4))
					self.swBrush(0,self.swHeight-self.lineHeight,self.swWidth,self.lineHeight)
					
					self:swSetColor(hsv(0,0,0.3))
				end
			);
			
		};
		
		class "BaseDriver"{
			metamethod"_init"
			:body(
				function(self)
					self.windowManager = trit.spine.WindowManager:new();
					
					self.windowManager:AddWindow(trit.spine.Commander,"Commander",300,500);
					self.cTabMessage = {}
					
					table.insert(self.cTabMessage,"Spine  version "..tostring(0.02).." alpha\n")
					table.insert(self.cTabMessage,"...loaded Commander")
					table.insert(self.cTabMessage,"................................................................")
					
				end
			);
			
			method"cOut"
			:body(
				function(self,data)
					table.insert(self.cTabMessage,data)
					--self.windowManager.tabWindows[1]:Out(data);
				end
			);
			
			--[[]]
			method"Init"
			:body(
				function(self)
				end
			);
			--]]
			method"Call"
			:body(
				function(self)
				end
			);
			
			method"Value"
			:body(
				function(self)
				end
			);
			
			method"Draw"
			:body(
				function(self)
				end
			);
			
			metamethod"__call"
			:body(
				function(self)
					self:Call()
					self:Value();
					self:Draw();
					for i = 1, table.getn(self.cTabMessage) do
						self.windowManager.tabWindows[1]:Out(self.cTabMessage[i]);
					end
					self.cTabMessage = {}
					
					self.windowManager();
				end
			);
			
		};
		
		class "Core"{
			metamethod"_init"
			:body(
				function(self)
					self.class = nil
				end
			);
		
			method"SetClass"
			:body(
				function(self,class)
					self.class = class;
				end
			);
			
			metamethod"__call"
			:body(
				function(self)
					if _TICKS()==2 then
						self.obj = self.class:new();
						self.obj:Init();
						
						
					end
					if _TICKS() >=2 then
						self.obj();

					end;
				end
			);
		};
	};
};

do
	local objSpine;
	function CallSpine(class)
		if _TICKS()==2 then
			objSpine = trit.spine.Core:new();
			objSpine:SetClass(class);
		end
		if _TICKS() >=2 then
			objSpine()
		end;
	end;
end;



namespace"test"{
	class "cmoge"
	:inherits(trit.spine.BaseDriver){
		method"Init"
		:attributes(override)
		:body(
			function(self)
			end
		);
		
		method"Call"
		:attributes(override)
		:body(
			function(self)
				--self:cOut()
			end
		);
		
		method"Value"
		:attributes(override)
		:body(
			function(self)
			end
		);
		
		method"Draw"
		:attributes(override)
		:body(
			function(self)
			end
		);
		
	};
};