# 무료로 계속 살아 있는 주소 만들기

이 폴더는 정적 사이트입니다. 무료로 오래 유지되는 주소가 필요하면 GitHub Pages가 가장 단순합니다.

## 매일 갱신 흐름

1. `outputs/YYYY-MM-DD/line.txt`와 `image.png`가 새로 생깁니다.
2. `scripts/Update-Manifest.ps1`을 실행해 `manifest.json`을 갱신합니다.
3. 바뀐 파일을 배포 저장소에 push합니다.
4. GitHub Pages가 같은 주소에서 새 날짜를 보여줍니다.

## 첫 배포 명령

GitHub에서 공개 저장소를 만든 뒤, 아래 명령을 한 번 실행합니다.

```powershell
.\scripts\Publish-GitHubPages.ps1 -RemoteUrl "https://github.com/계정명/저장소명.git"
```

GitHub 로그인 창이 뜨면 로그인합니다. 이후 같은 컴퓨터에서는 자격 증명이 저장되어 자동 push가 됩니다.

## 수동 갱신 명령

```powershell
.\scripts\Publish-GitHubPages.ps1
```

## 매일 자동 배포

첫 배포가 성공한 뒤 한 번만 실행합니다.

```powershell
.\scripts\Install-DailyPublishTask.ps1
```

## GitHub Pages 설정

1. GitHub에서 새 공개 저장소를 만듭니다.
2. `Publish-GitHubPages.ps1`로 이 폴더를 push합니다.
3. 저장소의 Settings > Pages에서 Deploy from a branch를 선택합니다.
4. Branch는 `main`, 폴더는 `/ (root)`로 둡니다.
5. 몇 분 뒤 `https://계정명.github.io/저장소명/` 주소가 열립니다.
