// #include <iostream>
// #include <stack>
// #include <vector>
// using namespace std;

// struct Tower
// {
//     Tower(int h, int i)
//     {
//         height = h;
//         id = i;
//     }

//     int height;
//     int id;
// };

// int main()
// {
//     cin.tie(0);
//     ios::sync_with_stdio(false);

//     int n; cin >> n;
//     vector<Tower> towers;
//     for (int i=0; i<n; ++i)
//     {
//         int h; cin >> h;
//         int index = i;
//         towers.push_back(Tower(h, index));
//     }

//     /*
//     6 9 5 7 4

//     위 벡터의 뒤부터 순차적으로 stack에 쌓아
//     (1) 4
//     (2) 4 7, 이때 4 < 7 이므로 4 pop
//     (3) 7
//     (4) 7 5
//     (5) 7 5 9 이때 5 < 9 이므로 9 pop
//     (6) 7 9   이때 7 < 9 이므로 7 pop
//     (7) 9
//     (8) 9 6
//     (9) 모두 돌았으니 종료
//     */

//     vector<int> result(n, 0);
//     stack<Tower> s;
//     s.push(towers[n - 1]);
//     for (int i=n-2; i>=0; --i)
//     {
//         if (s.empty()) break;

//         Tower curTower = towers[i];
//         while (!s.empty())
//         {
//             Tower top = s.top();
//             if (top.height < curTower.height)
//             {
//                 result[top.id] = curTower.id + 1;
//                 //cout << "current tower id = " << curTower.id << '\n';
//                 s.pop();
//             }
//             else
//             {
//                 break;
//             }
//         }
//         s.push(curTower);
//     }

//     for (auto& e : result)
//         cout << e << ' ';
// }

// 깔끔한 답
#include <iostream>
#include <stack>
using namespace std;

/*
6 9 5 7 4

앞에서 순차적으로 가면서 현재 높이와 전의 tower들 높이 비교
가장 처음에 제일 높은 수를 넣음
s = {6} => 현재 top = 가장높은수 + 1이므로     0 출력
s = {6, 9} => 6 < 9 이므로 6은 팝해버림. 그러면 또 가장 높은수가 남으니 0 출력
s = {9, 5} => 9 > 5 이니                      2  출력
s = {9, 5, 7} => 5 < 7 이니 5 pop 9를 만나   2 출력
s = {9, 7, 4} => 7 < 4 이니                 4 출력
*/
int main()
{
    ios::sync_with_stdio(false);
    cin.tie(0);

    int n; cin >> n;
    stack<pair<int, int>> towers;
    towers.push({100000001, 0});
    for (int i=1; i<=n; ++i)
    {
        int h; cin >> h;
        // 현재 타워보다 큰 높이만 남김
        while (towers.top().first < h)
        {
            towers.pop();
        }
        cout << towers.top().second << ' ';
        towers.push({h, i});
    }
}