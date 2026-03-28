// string 다루는거 친해지자

#include <iostream>
#include <deque>
#include <string>
using namespace std;

int main()
{
    cin.tie(0);
    ios::sync_with_stdio(false);

    /*
    뒤집기: reverse, 버리기: 첫 번째 수 버리기(배열이 비었다면 에러)
    초기값과 함수가 주어졌을 때 최종 결과
    뒤집으면 앞에서 뺄지 뒤에서 뺄지 결정(direction 바꿔)
    Deque를 사용해 direction에 따라 pop 하기
    */

    int t; cin >> t;
    while (t--)
    {
        string op; cin >> op;
        int n; cin >> n;
        deque<int> dq;

        string line; cin >> line;
        string currentNumberStr = "";
        for (auto& c : line)
        {
            if (isdigit(c))
            {
                currentNumberStr += c;
            }
            else if (c == ',' || c == ']')
            {
                if (currentNumberStr.empty()) continue;
                
                dq.push_back(stoi(currentNumberStr));
                currentNumberStr.clear();
            }
        }
            
        bool direction = false; // 0: 정방향, 1: 역방향
        bool isError = false;
        for (auto& c : op)
        {
            if (c == 'R')
            {
                direction = !direction;
            }
            else if (c == 'D')
            {
                if (dq.empty())
                {
                    isError = true;
                    break;     
                }

                if (direction)
                    dq.pop_back();
                else
                    dq.pop_front();
            }
            else
            {
                isError = true;
                break;
            }
        }

        if (isError)
        {
            cout << "error\n";
        }
        else
        {
            cout << "[";
            if (!direction)
            {
                while (!dq.empty())
                {
                    cout << dq.front();
                    dq.pop_front();
                    if (!dq.empty())
                        cout << ",";
                }
            }
            else
            {
                while (!dq.empty())
                {
                    cout << dq.back();
                    dq.pop_back();
                    if (!dq.empty())
                        cout << ",";
                }
            }
                
            cout << "]\n";
        }
    }
}