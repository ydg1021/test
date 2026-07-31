#!/usr/bin/env bash
# 로컬 세션용 Git 초기 세팅 스크립트
# 사용법:
#   bash setup-git.sh                          # 대화형으로 이름/이메일 입력
#   GIT_NAME="홍길동" GIT_EMAIL="me@mail.com" bash setup-git.sh   # 비대화형
set -euo pipefail

# 1. git 설치 확인
if ! command -v git >/dev/null 2>&1; then
  echo "[오류] git이 설치되어 있지 않습니다. 먼저 설치해 주세요."
  echo "  - Windows : https://git-scm.com/download/win (Git Bash 포함)"
  echo "  - macOS   : xcode-select --install  또는  brew install git"
  echo "  - Ubuntu  : sudo apt update && sudo apt install -y git"
  exit 1
fi
echo "git 확인: $(git --version)"

# 2. 사용자 정보 (기존 설정 > 환경변수 > 입력 순으로 결정)
current_name="$(git config --global user.name || true)"
current_email="$(git config --global user.email || true)"

name="${GIT_NAME:-$current_name}"
email="${GIT_EMAIL:-$current_email}"

if [ -z "$name" ]; then
  read -r -p "Git에서 사용할 이름 (예: ydg1021): " name
fi
if [ -z "$email" ]; then
  read -r -p "Git에서 사용할 이메일 (GitHub 계정 이메일): " email
fi

if [ -z "$name" ] || [ -z "$email" ]; then
  echo "[오류] 이름과 이메일은 필수입니다."
  exit 1
fi

git config --global user.name "$name"
git config --global user.email "$email"

# 3. 공통 기본 설정
git config --global init.defaultBranch main   # 새 레포 기본 브랜치를 main으로
git config --global core.quotepath false      # 한글 파일명이 이스케이프되지 않고 그대로 보이게
git config --global pull.rebase false         # pull 시 merge 방식(기본값 고정)
git config --global color.ui auto

# 4. OS별 설정 (줄바꿈 / 자격 증명 저장)
case "$(uname -s)" in
  MINGW*|MSYS*|CYGWIN*)
    git config --global core.autocrlf true
    git config --global credential.helper manager
    ;;
  Darwin)
    git config --global core.autocrlf input
    git config --global credential.helper osxkeychain
    ;;
  *)
    git config --global core.autocrlf input
    # 리눅스: 입력한 토큰을 1시간 동안 메모리에 캐시
    git config --global credential.helper 'cache --timeout=3600'
    ;;
esac

# 5. 결과 확인
echo
echo "===== 설정 완료 ====="
git config --global --list | grep -E '^(user|init|core|pull|credential)\.' || true
echo
echo "다음 단계: GIT_SETUP.md 문서를 참고해 레포를 clone 하세요."
echo "  git clone https://github.com/ydg1021/test.git"
