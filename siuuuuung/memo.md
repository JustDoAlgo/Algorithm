## 15683-감시

- 트리 레벨은 cctv의 개수, 이웃 노드 간 관계는 특정 cctv의 각기 다른 감시 방향조합(회전 케이스). 시간복잡도는 대략 4^k

```
- board에서 cctv의 개수들을 뽑고 위치, 타입을 따로 저장한다.
- 타입별 cctv 감시 방향조합을 데이터화해 딕셔너리에 저장한다. 이 때 방향 인덱스는 dr,dc를 순회하는 인덱스 방향과 동기화시켜야 한다.
- cctv를 하나의 레벨로 하는 dfs 트리를 순회한다. 
- 현재 cctv 타입의 방향 조합을 하나씩 순회해 각 바라보는 방향마다 watch()를 한다.
- watch()는 현재 direction의 방향만큼 계속 증가시키며 감시 범위를 -1로 체크해나간다. 벽 혹은 board 바깥일때까지 계속한다.
- 이를 가지고 있는 모든 cctv가 어떤 방향조합으로 모두 정의된 상황까지 계속, 즉 idx가 cctv length에 도달할때까지 계산하고 감시불가 범위를 ans와 비교해 갱신해간다.
```

## 2178 - 미로탐색

- '12345'를 list()로 돌리면 [1,2,3,4,5], split()으로 돌리면 [12345]
- sys.stdin.readline은 별 처리 안하고 바로 개행도 갖고와서 그래서 strip() 필요할 수도 있지만 input()보다 빠르다.
  - `board = [list(map(int,input().strip())) for _ in range(N)]`
- visited vs dist

## 7576-토마토

```python
# 파이써닉한 2차원 테이블 max값 찾기
for i in board:
    for j in i:
        if j == 0:
            print(-1)
            exit(0)
    ans = max(ans, max(i))
```

