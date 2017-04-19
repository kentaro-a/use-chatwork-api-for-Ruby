# Chatwork API操作クラス
# @url: http://developer.chatwork.com/ja/

require 'net/https'
require 'uri'
require 'json'

class Chatwork

	# イニシャライズ
	# apiToken: 自身のAPIトークン
	def initialize(apiToken)
		tokenHeaderKey = "X-ChatWorkToken: "
		@apiToken = apiToken										# APIトークン
		@reqHeader = "X-ChatWorkToken: #{@apiToken}"				# リクエストヘッダ
		@room = getRooms();        									# ルームＩＤ
	end


	# ルーム一覧取得
	def getRooms()
		ret = {}
		uri = URI.parse("https://api.chatwork.com/v2/rooms");
		
		# httpクラス
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		
		# httpリクエスト情報オブジェクト
		request = Net::HTTP::Get.new(uri.request_uri)
		request.add_field("X-ChatWorkToken", @apiToken)
		
		# httpレスポンス
		response = http.request(request)

		# ルーム名:ルームIDのハッシュにする
		JSON.parse(response.body).each{|data|
			ret[data["name"]] = data["room_id"]
		}
		return ret

	end
	private:getRooms


	# ルーム名からルームIDを取得する
	# roomName: ルーム名
	def getRoomID(roomName)
		return @room[roomName]
	end


	# メッセージを送る
	# roomid: ルームID
	# msg: メッセージ
	def sendMessage(roomid, msg)
		uri = URI.parse("https://api.chatwork.com/v2/rooms/#{roomid}/messages");

		# httpクラス
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE

		# httpリクエスト情報オブジェクト
		request = Net::HTTP::Post.new(uri.request_uri)
		request.set_form_data({'body'=>msg})
		request.add_field("X-ChatWorkToken", @apiToken)
		
		# ChatworkAPIにpostする
		http.request(request)
	end

end
