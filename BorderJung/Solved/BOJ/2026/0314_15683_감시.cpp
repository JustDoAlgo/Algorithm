// BOJ 15683 감시
/*
26.03.14 19:00~21:00
15683 감시
아니 풀릴 듯 안 풀릴 듯... 시뮬레이션은 디버깅을 빡세게 해야 하나
근데 이렇게 오래 걸려도 되는걸까...
*/

#include <iostream>
#include <algorithm>
using namespace std;

/*
1,2,3,4,5: CCTV. 각 CCTV 별로 회전 수는 정해짐
1, 3, 4: 네 방향 다 확인해야 함
2: 두 방향만 확인하면 됨
5: 한 방향만 확인하면 됨

### 감시 범위 확인하기.

주어진 방향으로 나아가는데 만약 (wall[x][y] == true || 범위 밖)이면 중지.

### CCTV가 여러 대일 때 계산을 어떻게 하나요?

그냥 매 번 계산하고 visited 확인하기?
재귀로 여러 번 돌리기?
예를 들면, 2번 카메라라 치면 <-> 모양으로 하나, ㅣ 모양으로 하나 재귀 돌리기

---

다시 정리하자면,

CCTV의 각도 경우의 수에 따른 빈 공간을 계산해야 한다는 것.

빈 공간 계산 = 채워진 공간 체크 => visited를 갱신하며 찾으면 된다.

문제는 'CCTV 각도 경우의 수' 구하기.

1: 상하좌우
2: 상하
3: 상하좌우
4: 상하좌우
5: 상

기록된 순서대로 가다가 CCTV를 만나면 거기서 재귀를 시작해. 그리고 인자로는 현재 좌표를 전달하는거지.
나중에 되돌리는건 어떻게? 자기가 바꾼 것만 되돌려야 해.

*/

int n, m, cctvCnt;
int board[10][10];
// 처음 등장한 CCTV 2번 좌표 = (cctvX[0], cctvY[0]). 2번인건 board에서 좌표값 확인하기
int cctvX[10]; // CCTV의 X좌표
int cctvY[10]; // CCTV의 Y좌표
// Wall
bool wall[10][10];
// 감시 범위
bool visited[10][10];
int result = 987654321;

void setChanged(int curR, int curC, int dr, int dc, bool changed[][10])
{
    while (0 <= curR && curR < n && 0 <= curC && curC < m && !wall[curR][curC])
    {
        if (!visited[curR][curC]) 
        {
            changed[curR][curC] = true;
        }
        curR += dr;
        curC += dc;
    }
}

void applyChangedToVisited(bool changed[][10])
{
    for (int i=0; i<n; ++i)
    {
        for (int j=0; j<m; ++j)
        {
            if (changed[i][j]) 
            {
                visited[i][j] = true;
            }
        }
    }
}

void resetVisited(bool changed[][10])
{
    //cout << "### Reset Arrays\n";
    for (int i=0; i<n; ++i)
    {
        for (int j=0; j<m; ++j)
        {
            if (changed[i][j]) 
            {
                visited[i][j] = false;
            }
        }
    }
    fill(&changed[0][0], &changed[0][0] + 100, false);
}

void resetChanged(bool changed[][10])
{
    fill(&changed[0][0], &changed[0][0] + 100, false); // 현재 CCTV가 바꿀 영역
}

void printVisited()
{
    cout << "CCTV 있어요~\n";
    for (int i=0; i<n; ++i)
    {
        for (int j=0; j<m; ++j)
        {
            cout << visited[i][j] << ' ';
        }
        cout << '\n';
    }
}

void func(int curR, int curC, int k)
{
    if (cctvCnt == k)
    {
        // 사각지대 계산
        int curResult = 0;
        for (int i=0; i<n; ++i)
        {
            for (int j=0; j<m; ++j)
            {
                if (visited[i][j] || wall[i][j]) continue;
                curResult += 1;
            }
        }
        
        // cout << "끝 !!! \n";
        // printVisited();

        result = min(result, curResult);

        return;
    }

    bool changed[10][10] = {false, };

    // 1번 CCTV는 4 방향
    if (board[curR][curC] == 1)
    {
        int dr[4] = {1,0,-1,0};
        int dc[4] = {0,1,0,-1};
        // 현재 방향으로 모두 체크
        for (int i=0; i<4; ++i)
        {
            int nr = curR + dr[i];
            int nc = curC + dc[i];
            setChanged(nr, nc, dr[i], dc[i], changed);
            applyChangedToVisited(changed);
            //printVisited();
            // 다음 CCTV 갱신
            func(cctvX[k+1], cctvY[k+1], k+1);
            // 원상복구
            resetVisited(changed);
        }
    }

    // 2번 CCTV는 2 방향
    if (board[curR][curC] == 2)
    {
        int dr[4] = {1,-1,0,0};
        int dc[4] = {0,0,1,-1};
        // 현재 방향으로 모두 체크
        for (int i=0; i<4; i+=2)
        {
            int nr0 = curR + dr[i];
            int nc0 = curC + dc[i];
            int nr1 = curR + dr[i+1];
            int nc1 = curC + dc[i+1];
            setChanged(nr0, nc0, dr[i], dc[i], changed);
            setChanged(nr1, nc1, dr[i+1], dc[i+1], changed);
            applyChangedToVisited(changed);
            //printVisited();
            // 다음 CCTV 갱신
            func(cctvX[k+1], cctvY[k+1], k+1);
            // 원상복구
            resetVisited(changed);
        }
    }

    // 3번 CCTV는 4 방향
    if (board[curR][curC] == 3)
    {
        int dr[4] = {1,0,-1,0};
        int dc[4] = {0,1,0,-1};
        // 현재 방향으로 모두 체크
        for (int i=0; i<4; ++i)
        {
            int nr0 = curR + dr[i];
            int nc0 = curC + dc[i];
            int nr1 = curR + dr[(i+1)%4];
            int nc1 = curC + dc[(i+1)%4];
            setChanged(nr0, nc0, dr[i], dc[i], changed);
            setChanged(nr1, nc1, dr[(i+1)%4], dc[(i+1)%4], changed);
            applyChangedToVisited(changed);
            //printVisited();
            // 다음 CCTV 갱신
            func(cctvX[k+1], cctvY[k+1], k+1);
            // 원상복구
            resetVisited(changed);
        }
    }

    // 4번 CCTV는 3 방향
    if (board[curR][curC] == 4)
    {
        int dr[4] = {1,0,-1,0};
        int dc[4] = {0,1,0,-1};
        // 현재 방향으로 모두 체크
        for (int i=0; i<4; ++i)
        {
            int nr0 = curR + dr[i];
            int nc0 = curC + dc[i];
            int nr1 = curR + dr[(i+1)%4];
            int nc1 = curC + dc[(i+1)%4];
            int nr2 = curR + dr[(i+2)%4];
            int nc2 = curC + dc[(i+2)%4];
            setChanged(nr0, nc0, dr[i], dc[i], changed);
            setChanged(nr1, nc1, dr[(i+1)%4], dc[(i+1)%4], changed);
            setChanged(nr2, nc2, dr[(i+2)%4], dc[(i+2)%4], changed);
            applyChangedToVisited(changed);
            //printVisited();
            // 다음 CCTV 갱신
            func(cctvX[k+1], cctvY[k+1], k+1);
            // 원상복구
            resetVisited(changed);
        }
    }

    // 5번 CCTV는 4 방향
    if (board[curR][curC] == 5)
    {
        int dr[4] = {1,0,-1,0};
        int dc[4] = {0,1,0,-1};
        // 현재 방향으로 모두 체크
        int nr0 = curR + dr[0];
        int nc0 = curC + dc[0];
        int nr1 = curR + dr[1];
        int nc1 = curC + dc[1];
        int nr2 = curR + dr[2];
        int nc2 = curC + dc[2];
        int nr3 = curR + dr[3];
        int nc3 = curC + dc[3];
        setChanged(nr0, nc0, dr[0], dc[0], changed);
        setChanged(nr1, nc1, dr[1], dc[1], changed);
        setChanged(nr2, nc2, dr[2], dc[2], changed);
        setChanged(nr3, nc3, dr[3], dc[3], changed);
        applyChangedToVisited(changed);
        //printVisited();
        // 다음 CCTV 갱신
        func(cctvX[k+1], cctvY[k+1], k+1);
        // 원상복구
        resetVisited(changed);
    }
}

int main()
{
    cin.tie(0);
    cout.tie(0);
    ios::sync_with_stdio(0);

    cin >> n >> m;

    int wallCnt = 0;
    bool hasCCTV = false;
    for (int i=0; i<n; ++i)
    {
        for (int j=0; j<m; ++j)
        {
            cin >> board[i][j];
            // CCTV
            if (1 <= board[i][j] && board[i][j] <= 5)
            {
                hasCCTV = true;
                visited[i][j] = true;
                cctvX[cctvCnt] = i;
                cctvY[cctvCnt] = j;
                cctvCnt += 1;
            }
            // Wall
            if (board[i][j] == 6)
            {
                wall[i][j] = true;
                wallCnt += 1;
            }
        }
    }
        
    if (hasCCTV)
    {
        //cout << "CCTV 개수 = " << cctvCnt << '\n';
        func(cctvX[0], cctvY[0], 0);
        cout << result;
    }
    else
    {
        cout << n * m - wallCnt;
    }
}