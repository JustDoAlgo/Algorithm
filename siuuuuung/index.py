import sys
from collections import deque

C, R = map(int, input().split())
board = [list(map(int, input().split())) for _ in range(R)]
dx = [0,1,0,-1]
dy = [-1,0,1,0]
ans = 0

q = deque([])

for i in range(R):
    for j in range(C):
        if board[i][j] == 1:
            q.append((i, j))

def bfs():
    while q:
        y, x = q.popleft()
        for d in range(4):
            nx, ny = x+dx[d], y+dy[d]
            if 0<=nx<C and 0<=ny<R and board[ny][nx] == 0:
                board[ny][nx] = board[y][x] + 1
                q.append((ny,nx))

bfs()
for i in board:
    for j in i:
        if j == 0:
            print(-1)
            exit(0)
    ans = max(ans, max(i))

print(ans-1)