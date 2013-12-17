---
title: Titanium Advent Calendar 2013
date: 2013-12-13 08:34 JST
tags: Titanium, Android, Advent Calendar 2013
author: いそべこーすけ
twitter: k0sukey
facebook: k0sukey
github: k0sukey
---

こちらは [Titanium™ Advent Calendar 2013](http://www.adventar.org/calendars/78) 用の記事になります。
余談ですが、企画された [@astronaughts](https://twitter.com/astronaughts) さんと、最近 Facebook で友達になりました。
やったね！

### はじめに
ぼくもちょこっとポエムを書かせてもらうと、今年は自分にとって大きな大きな 1 年でした。
JavaScript で iOS / Android アプリが書けちゃうなんて！と、ゆるい気持ちで使い始めたのですが、なんと会社まで立ち上げて Titanium 三昧でございます（最近はモジュールばかり書いていますけど）。
人生どうなるかわかりませんね。

### それでは本題に

外部ウェブサービス API へ POST する際、JSON の中身が意図されている順序で送信しないと受け付けられない場合があります。
AWS S3 へ直接ファイルをアップロードする場合等がそれですね。

iOS の場合は ```Ti.Network.HTTPClient``` の ```send()``` メソッドで意図されている順序の JSON を渡せばその順序で送信されますが、Android の場合そうはいきません。
[Titanium](https://github.com/appcelerator/titanium_mobile/blob/master/android/modules/network/src/java/ti/modules/titanium/network/TiHTTPClient.java#L1095) のソースコードを見てみると、Android の ```send()``` メソッドは ```HashMap``` で受け取っているため JSON の順序が保持されていません。
```LinkedHashMap``` であれば保持されるそうで、この問題は起きないのですがいつかこちらに切り替わるのでしょうか（期待できません）。

と、言うわけで、意図した通りの順序の JSON を送信する方法を探ってみましょう。
ここでは S3 へ直接ファイルをアップロードする方法を例にあげます。

#### まずはいつも通り ```Ti.Network.HTTPClient``` で ```send()``` する際に JSON を渡してしてみます
file はカメラで撮影した写真のデータ（```Ti.Blob```）が格納されており、その他、各変数は S3 へアップロードするために必要な情報となります。

	var xhr = Ti.Netwrok.createHTTPClient({
		onload: function(){},
		onerror: function(){}
	});
	xhr.open(url, 'POST');
	xhr.send({
		"key": key,
		"AWSAccessKeyId": AWSAccessKeyId,
		"acl": acl,
		"Content-Disposition": ContentDisposition,
		"Content-Type": ContentType,
		"success_action_redirect": successActionRedirect,
		"x-amz-server-side-encryption": xAmzServerSideEncryption,
		"policy": policy,
		"signature": signature,
		"file": file
	});

iOS はこれで問題なくアップロードできます。
key から始まって file まで ```send()```メソッドへ渡した際、JSON の順序が保持されているからです。
Android の場合は S3 から順序が正しくないとエラーが返却されてきます。
悲しいですね。

[リファレンス](http://docs.appcelerator.com/titanium/latest/#!/api/Titanium.Network.HTTPClient-method-send)を見てみましょう。
```send()``` メソッドは ```Object``` / ```String``` / ```Ti.Filesystem.File``` / ```Ti.Blob``` を指定することができます。
上記の例では JSON、つまり、```Object``` ですね。

#### Android で順序を保持したデータを渡すには HTTP リクエストの中身を自分で記述していきます

早速 JSON から離れますが ```String``` で送信してみます。

送信データを自前で記述する場合はいくつかのお作法があります。
ファイルを送信するのでリクエストヘッダは ```Content-Type: multipart/form-data``` となります（JSON で渡した場合は ```Ti.Blob``` が入っていると、このヘッダを勝手につけてくれます）。
さらに送信する内容一つずつに自前で区切りのサインを付けていかないとなりません。
下記の例では ```boundary``` という変数で用意しております。
こちらは任意の文字列となりますが、頭に必ず ```--``` を付けてください。
例ではタイムスタンプを ```Ti.Utils.md5HexDigest()``` しています。
また、一番最後の区切りには末尾にも ```--``` が必要となります。
改行コード（```\r\n```）も自分で記述しないといけません。
とても面倒ですね...。

	// 区切り文字
	var boundary = Ti.Utils.md5HexDigest('' + Date.now());

	// 写真を Ti.Stream で開いて Ti.Buffer 化
	var stream = Ti.Stream.createStream({
		mode : Ti.Stream.MODE_READ,
		source: file
	});
	var buffer = Ti.Stream.readAll(stream);
	stream.close();

	// 送信データを文字列で組み立てる
	var data = '--' + boundary + '\r\n' +
		'Content-Disposition: form-data; name="key"\r\n\r\n' +
		key + '\r\n' +
		'--' + boundary + '\r\n' +
		'Content-Disposition: form-data; name="AWSAccessKeyId"\r\n\r\n' +
		AWSAccessKeyId + '\r\n' +
		'--' + boundary + '\r\n' +
		'Content-Disposition: form-data; name="acl"\r\n\r\n' +
		acl + '\r\n' +
		'--' + boundary + '\r\n' +
		'Content-Disposition: form-data; name="Content-Disposition"\r\n\r\n' +
		ContentDisposition + '\r\n' +
		'--' + boundary + '\r\n' +
		'Content-Disposition: form-data; name="Content-Type"\r\n\r\n' +
		ContentType + '\r\n' +
		'--' + boundary + '\r\n' +
		'Content-Disposition: form-data; name="success_action_redirect"\r\n\r\n' +
		successActionRedirect + '\r\n' +
		'--' + boundary + '\r\n' +
		'Content-Disposition: form-data; name="x-amz-server-side-encryption"\r\n\r\n' +
		xAmzServerSideEncryption + '\r\n' +
		'--' + boundary + '\r\n' +
		'Content-Disposition: form-data; name="policy"\r\n\r\n' +
		policy + '\r\n' +
		'--' + boundary + '\r\n' +
		'Content-Disposition: form-data; name="signature"\r\n\r\n' +
		signature + '\r\n' +
		'--' + boundary + '\r\n' +
		'Content-Disposition: form-data; name="file"; filename="image.jpg"\r\n' +
		'Content-Type: binary/octet-stream\r\n\r\n' +
		buffer.toString() + '\r\n' + // Ti.Buffer を文字列化
		'--' + boundary + '--\r\n';

	// 送信
	var xhr = Ti.Netwrok.createHTTPClient({
		onload: function(){},
		onerror: function(){}
	});
	xhr.open(url, 'POST');
	xhr.setRequestHeader('Content-Type', 'multipart/form-data; boundary=' + boundary);
	xhr.send(data);

写真データのファイルを ```Ti.Stream``` で開いて、```readAll()``` で全て読み込んで ```Ti.Buffer``` にし、```toString()``` で文字列化しています。
これでどうでしょうか。

アップロードは成功しますが、画像ファイルの ```Ti.Buffer``` を ```toString()``` するとゴミが付くらしく、ファイルが壊れてしまいます（自前のサーバにアップロードしたファイルをバイナリエディタで開いて正常な画像と比較して確認しました）。
これでは意味がありませんね。

メールをプログラムから送信したことがある方は、似たような記述をしますのでピンときたかと思います。
```Ti.Buffer``` が ```toString()``` すると壊れてしまうのなら、```Ti.Blob``` なファイルを ```Ti.Utils.base64encode().toString()``` し、```Content-Transfer-Encoding: base64``` を付けて Base64 で送れば良いじゃない、と。
こんな感じですかね。

		'Content-Disposition: form-data; name="file"; filename="image.jpg"\r\n' +
		'Content-Type: binary/octet-stream\r\n' +
		'Content-Transfer-Encoding: base64\r\n\r\n' +
		Ti.Utils.base64encode(file).toString() + '\r\n' +
		'--' + boundary + '--\r\n';

...そもそも ```Content-Transfer-Encoding``` は[メール用](https://forums.aws.amazon.com/thread.jspa?threadID=108144)なんですね。
もちろん S3 はこのヘッダを受け付けてくれませんので、テキストファイルとしてアップロードされてしまいます。

それではどうするのか。

#### ```send()``` メソッドに ```Ti.Blob``` として送信データを渡します

	// 区切り文字
	var boundary = Ti.Utils.md5HexDigest('' + Date.now());

	// 送信データを Ti.Buffer で組み立てる
	data = Ti.createBuffer({
		value: '--' + boundary + '\r\n' +
		'Content-Disposition: form-data; name="key"\r\n\r\n' +
		key + '\r\n' +
		'--' + boundary + '\r\n' +
		'Content-Disposition: form-data; name="AWSAccessKeyId"\r\n\r\n' +
		AWSAccessKeyId + '\r\n' +
		'--' + boundary + '\r\n' +
		'Content-Disposition: form-data; name="acl"\r\n\r\n' +
		acl + '\r\n' +
		'--' + boundary + '\r\n' +
		'Content-Disposition: form-data; name="Content-Disposition"\r\n\r\n' +
		ContentDisposition + '\r\n' +
		'--' + boundary + '\r\n' +
		'Content-Disposition: form-data; name="Content-Type"\r\n\r\n' +
		ContentType + '\r\n' +
		'--' + boundary + '\r\n' +
		'Content-Disposition: form-data; name="success_action_redirect"\r\n\r\n' +
		successActionRedirect + '\r\n' +
		'--' + boundary + '\r\n' +
		'Content-Disposition: form-data; name="x-amz-server-side-encryption"\r\n\r\n' +
		xAmzServerSideEncryption + '\r\n' +
		'--' + boundary + '\r\n' +
		'Content-Disposition: form-data; name="policy"\r\n\r\n' +
		policy + '\r\n' +
		'--' + boundary + '\r\n' +
		'Content-Disposition: form-data; name="signature"\r\n\r\n' +
		signature + '\r\n' +
		'--' + boundary + '\r\n' +
		'Content-Disposition: form-data; name="file"; filename="image.jpg"\r\n' +
		'Content-Type: binary/octet-stream\r\n\r\n'
	});

	// 写真を Ti.Stream で開いて Ti.Buffer 化し、送信データへ追加
	stream = Ti.Stream.createStream({
		mode : Ti.Stream.MODE_READ,
		source: file
	});
	data.append(Ti.Stream.readAll(stream));
	stream.close();

	// 最後の区切り文字を追加
	data.append(Ti.createBuffer({
		value: '\r\n--' + boundary + '--\r\n'
	}));

	// 送信
	var xhr = Ti.Netwrok.createHTTPClient({
		onload: function(){},
		onerror: function(){}
	});
	xhr.open(url, 'POST');
	xhr.setRequestHeader('Content-Type', 'multipart/form-data; boundary=' + boundary);
	xhr.send(data.toBlob());

これでどうでしょう。
見事ファイルも壊れずアップロードすることができました。

ザックリと何をしているかというと、```Ti.Buffer``` として送信データを作って、最後に ```toBlob()``` で ```Ti.Blob``` 化して送信しています。
正直、何を書いているのか、わけがわからなくなりますね。

#### 最後にHTML のフォームに例えてみましょう

	<form action="url" method="post" enctype="multipart/form-data">
		<input type="hidden" name="key" value="key">
		<input type="hidden" name="AWSAccessKeyId" value="AWSAccessKeyId">
		<input type="hidden" name="acl" value="acl">
		<input type="hidden" name="Content-Disposition" value="ContentDisposition">
		<input type="hidden" name="Content-Type" value="ContentType">
		<input type="hidden" name="success_action_redirect" value="successActionRedirect">
		<input type="hidden" name="x-amz-server-side-encryption" value="xAmzServerSideEncryption">
		<input type="hidden" name="policy" value="policy">
		<input type="hidden" name="signature" value="signature">
		<input type="file" name="file">
		<input type="submit" value="send">
	</form>

HTML だととても簡単ですね！

### 〆
少々コードが煩雑になってしまうのであまりオススメできませんが、どうしてもという方はこちらの方法で送信することができます。
ぼくは早く ```LinkedHashMap``` にならないかと、首を長くして待っております（まったく期待できません）。

### 14日目の方
[@h5y1m141](https://twitter.com/h5y1m141) さんです。
ACS ネタ、楽しみですね！