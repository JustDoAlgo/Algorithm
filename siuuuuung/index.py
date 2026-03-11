# 0은 빈칸, 6은 벽, 1,2,3,4,5는 cctv 타입

import sys
input = sys.stdin.readline

N, M = map(int, input().split())
board = [list(map(int, input().split())) for _ in range(N)]

dr= [-1,0,1,0]
dc= [0,1,0,-1]

# 가리키는 방향 => 0,1,2,3 = 상우하좌 (dr, dc와 맞춘 것)
cctv_dirs = {
    1: [[0],[1],[2],[3]],
    2: [[0,2], [1,3]],
    3: [[0,1],[1,2],[2,3],[3,0]],
    4: [[0,1,3], [0,1,2], [1,2,3],[0,2,3]],
    5: [[0,1,2,3]]
}

ans = 10**9

cctvs= []
for r in range(N):
    for c in range(M):
        if 1<=board[r][c]<=5:
            cctvs.append((r,c,board[r][c]))


def watch(temp, r,c,d):
    nr, nc = r + dr[d], c + dc[d]

    while 0<= nr < N and 0<=nc<M:
        if temp[nr][nc] == 6: # 벽 만나면 중단
            break

        if temp[nr][nc] == 0:
            temp[nr][nc] = -1
        
        nr += dr[d]
        nc += dc[d]


def dfs(idx, temp):
    global ans

    if idx == len(cctvs):
        blind = 0
        for r in range(N):
            for c in range(M):
                if temp[r][c] == 0:
                    blind += 1
        ans = min(ans, blind)
        return

    r,c,t = cctvs[idx]

    # 현재 cctv 타입의 
    for dirs in cctv_dirs[t]: # [[0,1],[1,2], ...]
        new_temp = [row[:] for row in temp] # 보드 복사
        
        for d in dirs: 
            watch(new_temp, r,c,d) # r,c 좌표에서 d 방향 바라보기
        
        dfs(idx+1, new_temp)

dfs(0, board)
print(ans)