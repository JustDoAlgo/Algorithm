#include <iostream>
#include <stack>
#include <vector>
using namespace std;
#define h first
#define id second

/*
하나씩 타워 값을 받으면서
만약 현재가 Stack top보다 크다면? top은 이제 필요 없음. 제거 --> 이거는 반복
현재가 Stack top 보다 작으면, 현재 타워의 값은 top임.
*/
int main()
{
    cin.tie(0);
    ios::sync_with_stdio(0);

    int n; cin >> n;
    int h;
    stack<pair<int, int>> tower;
    vector<int> result(n, 0);
    for (int i=0; i<n; ++i)
    {
        cin >> h;

        if (tower.empty())
        {
            tower.push({h, i});
            continue;
        }

        while (!tower.empty() && h > tower.top().h)
        {
            tower.pop();
        }

        if (!tower.empty())
            result[i] = tower.top().id + 1;

        tower.push({h, i});
    }
    for (auto e : result)
        cout << e << ' ';
}

// // 깔끔한 답
// #include <iostream>
// #include <stack>
// using namespace std;

// /*
// 6 9 5 7 4

// 앞에서 순차적으로 가면서 현재 높이와 전의 tower들 높이 비교
// 가장 처음에 제일 높은 수를 넣음
// s = {6} => 현재 top = 가장높은수 + 1이므로     0 출력
// s = {6, 9} => 6 < 9 이므로 6은 팝해버림. 그러면 또 가장 높은수가 남으니 0 출력
// s = {9, 5} => 9 > 5 이니                      2  출력
// s = {9, 5, 7} => 5 < 7 이니 5 pop 9를 만나   2 출력
// s = {9, 7, 4} => 7 < 4 이니                 4 출력
// */
// int main()
// {
//     ios::sync_with_stdio(false);
//     cin.tie(0);

//     int n; cin >> n;
//     stack<pair<int, int>> towers;
//     towers.push({100000001, 0});
//     for (int i=1; i<=n; ++i)
//     {
//         int h; cin >> h;
//         // 현재 타워보다 큰 높이만 남김
//         while (towers.top().first < h)
//         {
//             towers.pop();
//         }
//         cout << towers.top().second << ' ';
//         towers.push({h, i});
//     }
// }