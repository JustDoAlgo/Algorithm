# 1. 스티커를 하나씩 순회
# 2. 각 스티커마다 행, 열 각각 0~R-r, 0~C-c 범위만큼 순회
# 2-1. 규격에 벗어나지 않는 경우 기존 스티커와 겹치는지 check() 검사. 
#      검사 통과시 attach()로 notebook에 스티커 기록하고 검사 중단 후 다음 스티커인 1로 돌아감
# 3. 현재 방향에 실패하면 현재 스티커를 회전시키고 2로 돌아감
# 4. notebook에서 1의 개수 출력

# 얻어간것 


R, C, K = map(int, input().split()) # k = 스티커 개수

notebook = [[0]*C for _ in range(R)]
stickers = []
for _ in range(K): # 스티커 입력받기
    r,c = map(int, input().split())
    tmp = [list(map(int,input().split())) for _ in range(r)]
    stickers.append(tmp)


def isOverlapped(sticker, sy, sx):
    for i in range(len(sticker)):
        for j in range(len(sticker[0])):
            if sticker[i][j] == 1 and notebook[sy+i][sx+j] == 1:
                return True
    return False


def attach(sticker, sy, sx):
    for i in range(len(sticker)):
        for j in range(len(sticker[0])):
            if sticker[i][j]==1:
                notebook[sy+i][sx+j]=1


def rotate(sticker):
    r = len(sticker)
    c = len(sticker[0])
    rotated = [[0]*r for _ in range(c)]
    
    for i in range(r):
        for j in range(c):
            rotated[j][r-1-i] = sticker[i][j]

    return rotated

for sticker in stickers:
    attached = False

    for _ in range(4):
        r = len(sticker)
        c = len(sticker[0])

        for i in range(R-r+1):
            if attached:
                break
            for j in range(C-c+1):
                if not isOverlapped(sticker, i, j):
                    attach(sticker, i, j)
                    attached = True
                    break


        if attached:
            break

        sticker = rotate(sticker) 


ans = 0
for i in notebook:
    for j in i:
        if j==1:
            ans +=1

print(ans)