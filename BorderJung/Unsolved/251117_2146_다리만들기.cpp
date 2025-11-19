// 재시도 횟수: 1/3 (25.11.19/ / )
#include <iostream>
#include <queue>
#include <vector>
#include <algorithm>
using namespace std;
#define x first
#define y second
int dx[4] = {1,0,-1,0};
int dy[4] = {0,1,0,-1};

/*
1. 각 섬 indexing 하기
2. 만약 다른 인덱싱의 섬을 만나면 최솟값 갱신
*/

int board[102][102];
int visited[102][102];
int n;
vector<int> results;

void indexingIsland(int x, int y, int index)
{
    board[x][y] = index;
    queue<pair<int, int>> q;
    q.push({x, y});
    visited[x][y] = 0;
    while (!q.empty())
    {
        auto here = q.front(); q.pop();
        for (int i=0; i<4; ++i)
        {
            int nx = here.x + dx[i];
            int ny = here.y + dy[i];
            if (nx < 0 || nx >= n || ny < 0 || ny >= n) continue;
            if (visited[nx][ny] == -1 && board[nx][ny] == 1)
            {
                board[nx][ny] = index;
                visited[nx][ny] = 0;
                q.push({nx, ny});
            }
        }
    }
}

void buildBridge(int x, int y)
{
    queue<pair<int, int>> q;
    q.push({x, y});
    visited[x][y] = 0;
    while (!q.empty())
    {
        auto here = q.front(); q.pop();
        for (int i=0; i<4; ++i)
        {
            int nx = here.x + dx[i];
            int ny = here.y + dy[i];
            if (nx < 0 || nx >= n || ny < 0 || ny >= n) continue;
            // 만약 다음 섬을 찾았으면, 현재 다리 길이를 저장
            // 현 시작 점에서의 다리는 끝났으니 종료
            if (board[nx][ny] > 0 && board[nx][ny] != board[x][y])
            {
                results.push_back(visited[here.x][here.y]);
                return;
            }
            //  바다이면 전진
            if (visited[nx][ny] == -1 && board[nx][ny] == 0)
            {
                visited[nx][ny] = visited[here.x][here.y] + 1;
                q.push({nx, ny});
            }
        }
    }
}

void printBoard();
void printVisited();
void initFlag();

int main()
{
    ios::sync_with_stdio(0);
    cin.tie(0);

    cin >> n;
    for (int i=0; i<n; ++i)
        for (int j=0; j<n; ++j)
            cin >> board[i][j];

    initFlag();
    int index = 0;
    for (int i=0; i<n; ++i)
    {
        for (int j=0; j<n; ++j)
        {
            if (visited[i][j] == -1 && board[i][j] == 1)
            {
                index += 1;
                indexingIsland(i, j, index);                
            }
        }
    }

    initFlag();
    for (int i=0; i<n; ++i)
    {
        for (int j=0; j<n; ++j)
        {
            if (visited[i][j] == -1 && board[i][j] > 1)
            {
                initFlag(); // 시작점을 정했으면, 방문 여부를 초기화하고 시작해야 한다.
                buildBridge(i, j);
            }
        }
    }

    if (results.empty()) cout << "결과값은 0개 입니다.";
    else cout << *min_element(results.begin(), results.end());
}

void printBoard()
{
    cout << "\n======Print Board=======\n\n";
    for (int i=0; i<n; ++i)
    {
        for (int j=0; j<n; ++j)
        {
            cout << board[i][j] << ' ';
        }
        cout << '\n';
    }
    cout << "\n\n";
}

void printVisited()
{
    cout << "\n======Print visited=======\n\n";
    for (int i=0; i<n; ++i)
    {
        for (int j=0; j<n; ++j)
        {
            cout << visited[i][j] << ' ';
        }
        cout << '\n';
    }
    cout << "\n\n";
}

void initFlag()
{
    if (n == 0) 
    {
        cout << "아직 n이 초기화되지 않음\n";
        return;
    }
    for (int i=0; i<n; ++i)
        fill(visited[i], visited[i] + n, -1);
}