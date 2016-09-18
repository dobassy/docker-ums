exlair/ums
============

Introduction
-------------
Dockerfile to build a [Universal Media Server](http://www.universalmediaserver.com/) (UMS) container image. based on Ubuntu:16.04.  
README is written in Japanese Only.

### Version
Current Version (2016.09): exlair/ums:6.5.0  
**Note**: The update frequency of this container image will be irregular.


Installation
--------------

	$ git clone https://github.com/exlair/docker-ums.git
	
	$ docker build -t exlair/ums:6.5.0 ./clone-repository
	   or
	$ make release


Quick Start
--------------

Example usage:

	$ docker run -d --net=host --restart=always \
	  -p 5001:5001 -p 9001:9001
	  -v /path/to/your/mediavolume:/media \
	  --name ums exlair/ums:6.5.0

or if eth0 is not the default network:

	$ docker run -d --net=host --restart=always \
	  -p 5001:5001 -p 9001:9001
	  -v /path/to/your/mediavolume:/media \
	  -e X_UMS_NETWORK_INTERFACES=ens33
	  --name ums exlair/ums:6.5.0

set your interface name to `X_UMS_NETWORK_INTERFACES` env.

You can also start using the `docker-compose` command. Please refer to the `docker-compose.yml.sample` file.

Restriction
--------------
- DockerHubレポジトリへの登録を行っていないためビルドが必要です。
- PlayStation 3 or 4 で動画視聴をする目的しかありませんので、音楽再生などその他用途のためには設定が不足している可能性が高いです。動作確認をしておりません
- 伴って、同梱の `UMS.conf` ではいくつかの項目を削除しています。削除してもデフォルト設定で動作しますので実害はありませんが、必要に応じて conf を上書きしてください。


Configuration
--------------
初期値として、 `UMS.conf` と `WEB.conf` のデフォルト設定がコンテナ内に配置されています。多くの場合、映像ファイルの配置ディレクトリ設定等のチューニングを行いたいと思いますので、初期設定値では不足するものと想定しています。

その場合、ホストマシンの任意のディレクトリに `UMS.conf` と `WEB.conf` の2ファイルを用意し、ボリュームをマウントしてください。

~~
docker run -d -v /path/to/yourhost/conf:/srv/ums/conf \
  --name ums exlair/ums:6.5.0
~~

### Available Configuration Parameters
設定ファイルのうち、いくつかの値は環境変数により設定可能です（以下リスト）。これで足りる場合は、設定ファイルをマウントするよりも手軽に利用することができます。

Below is the list of parameters that can be set using environment variables.

* **X_UMS_FOLDERS**: default "`/media`"
* **X_UMS_NETWORK_INTERFACES**: default "`eth0`"
* **X_UMS_SKIP_NETWORK_INTERFACES**: "`tap,vmnet,vnic`"
* **X_UMS_ENGINES**: default "`ffmpegvideo,mencoder,tsmuxer,ffmpegaudio,tsmuxeraudio,ffmpegwebvideo,vlcwebvideo,vlcvideo,mencoderwebvideo,vlcaudio,ffmpegdvrmsremux,rawthumbs`"


Specification
--------------

- `/srv/ums` をホームディレクトリ & UMS配置ディレクトリとしています。
- 設定ファイル (`UMS.conf`, `WEB.conf`) を `./conf` ディレクトリに配置しているため、`docker run` のタイミングでホストのディレクトリをマウントすることでファイルを上書き可能です。
- 一部の設定項目を環境変数で設定可能とするために、[Entrykit][entrykit] を利用しています。

Directory Structure:

~~
-rwxr-xr-x    ums      ums   UMS.sh
lrwxrwxrwx    ums      ums   UMS.conf -> conf/UMS.conf
lrwxrwxrwx    ums      ums   WEB.conf -> conf/WEB.conf
drwxr-xr-x    ums      ums   conf

~ $ ls -al ./conf/
drwxr-xr-x    ums      ums    .
drwxr-sr-x    ums      ums    ..
-rw-r--r--    ums      ums    UMS.conf
-rw-r--r--    ums      ums    WEB.conf
~~

References
--------------
- [Universal Media Server](http://www.universalmediaserver.com/) - Official site
	- [UniversalMediaServer/INSTALL.txt at master · UniversalMediaServer/UniversalMediaServer · GitHub](https://github.com/UniversalMediaServer/UniversalMediaServer/blob/master/INSTALL.txt)
	- [UniversalMediaServer/UMS.conf at master · UniversalMediaServer/UniversalMediaServer · GitHub](https://github.com/UniversalMediaServer/UniversalMediaServer/blob/master/src/main/external-resources/UMS.conf)
- [progrium/entrykit: Entrypoint tools for elegant, programmable containers][entrykit]


[entrykit]: https://github.com/progrium/entrykit "progrium/entrykit: Entrypoint tools for elegant, programmable containers"
