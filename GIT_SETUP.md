# 로컬 세션 Git 세팅 가이드

로컬(내 컴퓨터)에서 이 레포로 작업하기 위한 Git 설치·설정 방법입니다.

## 1. Git 설치

| OS | 방법 |
|---|---|
| Windows | https://git-scm.com/download/win 에서 설치 (Git Bash 포함됨) |
| macOS | 터미널에서 `xcode-select --install` 또는 `brew install git` |
| Ubuntu/Debian | `sudo apt update && sudo apt install -y git` |

설치 확인:

```bash
git --version
```

## 2. 자동 세팅 (권장)

레포에 포함된 스크립트 하나로 기본 설정이 끝납니다. Windows는 **Git Bash**에서 실행하세요.

```bash
bash setup-git.sh
```

이름/이메일을 물어보면 GitHub 계정 정보를 입력하면 됩니다. 스크립트가 설정하는 것:

- `user.name` / `user.email` — 커밋 작성자 정보
- `init.defaultBranch main` — 새 레포 기본 브랜치를 `main`으로
- `core.quotepath false` — 한글 파일명이 `"\353\223\234..."`처럼 깨져 보이지 않게
- `core.autocrlf` — OS에 맞는 줄바꿈 처리 (Windows: `true`, macOS/Linux: `input`)
- `credential.helper` — 비밀번호(토큰)를 매번 입력하지 않도록 OS별 저장소 사용

수동으로 하고 싶다면:

```bash
git config --global user.name "이름"
git config --global user.email "GitHub이메일"
git config --global init.defaultBranch main
git config --global core.quotepath false
```

## 3. 레포 가져오기 (clone)

```bash
git clone https://github.com/ydg1021/test.git
cd test
```

### GitHub 인증

HTTPS로 push할 때 비밀번호 대신 **Personal Access Token(PAT)** 이 필요합니다.

1. GitHub → Settings → Developer settings → Personal access tokens → **Generate new token**
2. `repo` 권한 체크 후 생성, 토큰 문자열 복사
3. push 시 비밀번호 자리에 토큰을 붙여넣기 (credential helper가 이후 기억함)

또는 [GitHub CLI](https://cli.github.com/)로 간단히: `gh auth login`

## 4. 기본 작업 흐름

```bash
git pull origin main          # 작업 전: 최신 내용 받기
# ... 파일 수정 ...
git add .                     # 변경 파일 스테이징
git commit -m "작업 내용 설명"   # 커밋
git push origin main          # GitHub에 올리기
```

상태 확인은 `git status`, 이력 확인은 `git log --oneline` 을 사용하세요.

## 5. Colab과 같이 쓸 때 주의

이 레포는 Colab에서도 저장("Colab을 통해 생성됨" 커밋)이 일어납니다. 로컬과 Colab 양쪽에서 작업하면 충돌이 날 수 있으니:

- 로컬 작업을 **시작하기 전에 항상 `git pull`** 을 먼저 실행
- push가 거부되면(`rejected`) `git pull origin main` 으로 원격 변경을 먼저 합친 뒤 다시 push
