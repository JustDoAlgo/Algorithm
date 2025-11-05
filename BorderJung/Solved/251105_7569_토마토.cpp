#include <iostream>
#include <queue>
using namespace std;
#define x first
#define y second

int board[102][102][102];
int t[102][102][102];
int dx[6] = {1,0,-1,0,0,0};
int dy[6] = {0,1,0,-1,0,0};
int dz[6] = {0,0,0,0,1,-1};
int m, n, h;

int main()
{
    cin.tie(0);
    ios::sync_with_stdio(0);

    cin >> m >> n >> h;
    for (int x=0; x<m; ++x)
    {
        for (int y=0; y<n; ++y)
        {
            fill(t[x][y], t[x][y] + h, -1);
        }
    }

    queue<tuple<int, int, int>> q; // 튜플을 사용하자 !! 원소 3개? 튜플 쓰기
    for (int z=0; z<h; ++z)
    {
        for (int y=0; y<n; ++y)
        {
            for (int x=0; x<m; ++x)
            {
                cin >> board[x][y][z];
                if (board[x][y][z] == 1)
                {
                    q.push({x, y, z}); // 튜플도 똑같이 중괄호로 넣는다
                    t[x][y][z] = 0;
                }
            }
        }
    }

    while (!q.empty())
    {
        auto here = q.front(); q.pop();
        int curx, cury, curz;
        tie(curx, cury, curz) = here;
        for (int i=0; i<6; ++i)
        {
            int nx = curx + dx[i];
            int ny = cury + dy[i];
            int nz = curz + dz[i];
            if (nx < 0 || nx >= m || ny < 0 || ny >= n || nz < 0 || nz >= h) continue;
            if (t[nx][ny][nz] != -1 || board[nx][ny][nz] == -1) continue;
            q.push({nx, ny, nz});
            t[nx][ny][nz] = t[curx][cury][curz] + 1;
        }
    }

    int result = -1;
    for (int z=0; z<h; ++z)
    {
        for (int y=0; y<n; ++y)
        {
            for (int x=0; x<m; ++x)
            {
                if (board[x][y][z] == 0 && t[x][y][z] == -1)
                {
                    cout << -1;
                    return 0;
                }
                result = max(result, t[x][y][z]);
            }
        }
    }
    cout << result;
}


/* 아래는 내 풀이 */
// #include <iostream>
// #include <queue>
// using namespace std;
// #define x first
// #define y second

// int board[102][102][102];
// int t[102][102][102];
// int dx[6] = {1,0,-1,0,0,0};
// int dy[6] = {0,1,0,-1,0,0};
// int dz[6] = {0,0,0,0,1,-1};
// int m, n, h;

// struct Node
// {
//     int x, y, z;
//     Node(int _x, int _y, int _z):x(_x), y(_y), z(_z){}
// };

// int main()
// {
//     cin.tie(0);
//     ios::sync_with_stdio(0);

//     cin >> m >> n >> h;
//     for (int x=0; x<m; ++x)
//     {
//         for (int y=0; y<n; ++y)
//         {
//             fill(t[x][y], t[x][y] + h, -1);
//         }
//     }

//     queue<Node> q;
//     for (int z=0; z<h; ++z)
//     {
//         for (int y=0; y<n; ++y)
//         {
//             for (int x=0; x<m; ++x)
//             {
//                 cin >> board[x][y][z];
//                 if (board[x][y][z] == 1)
//                 {
//                     q.push(Node(x, y, z));
//                     t[x][y][z] = 0;
//                 }
//             }
//         }
//     }

//     while (!q.empty())
//     {
//         Node here = q.front(); q.pop();
//         for (int i=0; i<6; ++i)
//         {
//             int nx = here.x + dx[i];
//             int ny = here.y + dy[i];
//             int nz = here.z + dz[i];
//             if (nx < 0 || nx >= m || ny < 0 || ny >= n || nz < 0 || nz >= h) continue;
//             if (t[nx][ny][nz] != -1 || board[nx][ny][nz] == -1) continue;
//             q.push(Node(nx, ny, nz));
//             t[nx][ny][nz] = t[here.x][here.y][here.z] + 1;
//         }
//     }

//     int result = -1;
//     for (int z=0; z<h; ++z)
//     {
//         for (int y=0; y<n; ++y)
//         {
//             for (int x=0; x<m; ++x)
//             {
//                 if (board[x][y][z] == 0 && t[x][y][z] == -1)
//                 {
//                     cout << -1;
//                     return 0;
//                 }
//                 result = max(result, t[x][y][z]);
//             }
//         }
//     }
//     cout << result;
// }