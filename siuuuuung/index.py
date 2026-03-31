from collections import deque


board = [list(input().strip()) for _ in range(12)]

dx,dy = [0,1,0,-1],[-1,0,1,0]

def drop_blocks(board):
    # board의 열을 아래부터 순회하며 
    for c in range(6):
    # .이 아닌 블록만 하나씩 따로 큐에 저장하고 .으로 바꿔버리기
        col = [board[r][c] for r in range(12)]
        q = deque()

        for i in range(11, -1,-1):
            if col[i] != '.':
                q.append(col[i])
                board[i][c] = '.'
        
        # 그 열을 아래부터 재순회하며 .이면 블록 배치, 큐가 비면 그냥 .
        for i in range(11, -1, -1):
            if board[i][c] == '.' and q:
                board[i][c] = q.popleft()
    
    return 


def bfs(y, x, board):
    tmp = [(y,x)]
    q = deque([(y,x)])
    visited[y][x] = True

    while q:
        r,c = q.popleft()

        for d in range(4):
            nx = c + dx[d]
            ny = r + dy[d]

            if 0<=nx<6 and 0<=ny<12:
                if not visited[ny][nx] and board[ny][nx] == board[y][x]:
                    tmp.append((ny,nx))
                    q.append((ny,nx))
                    visited[ny][nx] = True
    
    # 같은 색 칸 bfs 진행이 4이상이면 삭제 목록에 저장
    if len(tmp) >= 4:
        removals.extend(tmp)
    

    return

boom_cnt = 0

while True:
    # 방문처리, 제거목록 선언
    visited, removals = [[False]*6 for _ in range(12)], []
    
    # 전체 순회
    for i in range(12):
        for j in range(6):
            # 미방문 색깔칸이면 bfs
            if board[i][j] !='.' and not visited[i][j]:
                bfs(i, j, board)
    
    # 연쇄가 없으면 종료
    if not removals:
        break

    # 연쇄처리 하기
    for y,x in removals:
        board[y][x] = '.'
    boom_cnt += 1

    drop_blocks(board)

print(boom_cnt)
