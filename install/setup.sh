#!/bin/bash

jms_version="version-dev"
jms_edition="ce"
tmp_dir="/tmp/jms_install"

tag=$(docker ps -a | grep jms_core | awk '{print $2}' | awk -F':' '{print $2}')

install() {
    echo "正在安装深色主题~"
    jmsctl stop
    mkdir -p "$tmp_dir"

    if [ ! -d "jms_web" ] || [ ! -f "lina-dark.tar.gz" ] || [ ! -d "jms_core" ]; then
        echo "检测到安装包不完整~"
        echo "安装已终止~"
        exit 1
    fi

    if ! docker image inspect "jumpserver/web:$tag-light" > /dev/null 2>&1; then
        docker tag "jumpserver/web:$tag" "jumpserver/web:$tag-light"
        docker rmi "jumpserver/web:$tag"
    fi
    if ! docker image inspect "jumpserver/core:$tag-light" > /dev/null 2>&1; then
        docker tag "jumpserver/core:$tag" "jumpserver/core:$tag-light"
        docker rmi "jumpserver/core:$tag"
    fi

    if ! docker image inspect "jumpserver/web:$tag-dark" > /dev/null 2>&1; then
        cp -r "jms_web" "$tmp_dir/"
        tar -xzf "lina-dark.tar.gz" -C "$tmp_dir/jms_web" > /dev/null 2>&1;
        sed -i "s/dark-tag/$tag-light/g" "$tmp_dir/jms_web/Dockerfile"
        docker build -t "jumpserver/web:$tag-dark" "$tmp_dir/jms_web"
    fi
    if ! docker image inspect "jumpserver/core:$tag-dark" > /dev/null 2>&1; then
        cp -r "jms_core" "$tmp_dir/"
        sed -i "s/dark-tag/$tag-light/g" "$tmp_dir/jms_core/Dockerfile"
        docker build -t "jumpserver/core:$tag-dark" "$tmp_dir/jms_core"
    fi


    docker tag "jumpserver/web:$tag-dark" "jumpserver/web:$tag"
    docker tag "jumpserver/core:$tag-dark" "jumpserver/core:$tag"

    jmsctl start
    docker images -f "dangling=true" -q | xargs -r docker rmi
    rm -rf "$tmp_dir"
}

uninstall() {
    echo "正在卸载~"
    jmsctl stop

    if docker image inspect "jumpserver/web:$tag-light" > /dev/null 2>&1; then
        docker rmi "jumpserver/web:$tag"
        docker tag "jumpserver/web:$tag-light" "jumpserver/web:$tag"
        docker rmi "jumpserver/web:$tag-light"
        docker rmi "jumpserver/web:$tag-dark"
    fi
    if docker image inspect "jumpserver/core:$tag-light" > /dev/null 2>&1; then
        docker rmi "jumpserver/core:$tag"
        docker tag "jumpserver/core:$tag-light" "jumpserver/core:$tag"
        docker rmi "jumpserver/core:$tag-light"
        docker rmi "jumpserver/core:$tag-dark"
    fi

    jmsctl start
    docker images -f "dangling=true" -q | xargs -r docker rmi
}

ask_continue() {
    while true; do
        read -p "$1 (Y/n): " choice
        case "$choice" in
            Y|y ) install; break ;;
            n|N ) echo "安装已取消。"; break ;;
            * ) echo "无效输入，请输入 Y 或 n." ;;
        esac
    done
}


check() {
    if [[ "$tag" == "$jms_version-$jms_edition" ]]; then
        install
    elif [[ "$tag" == "$jms_version"* ]]; then
        ask_continue "目前堡垒机版本为:$tag，当前主题版本: $jms_version-$jms_edition，对非社区版没有完全黑化，是否继续安装?"
    else
        ask_continue "目前堡垒机版本为:$tag，当前主题版本: $jms_version-$jms_edition，堡垒机版本不一致，是否继续安装?"
    fi
}


if [ -z "$tag" ]; then
      echo "错误: 无法获取目前的版本，请启动堡垒机再试，安装已终止。"
      exit 1
fi
case "$1" in
    install)
        check
        ;;
    uninstall)
        uninstall
        ;;
    *)
        echo "Use: $0 {install|uninstall}"
        exit 1
        ;;
esac
