/*
2941 크로아티아 알파벳
26.03.23 21:05~
메모
### find() 메서드와 replace() 메서드 사용법
- find(pattern, index_pos);
- replace(pattern, length, str)
*/

#include <iostream>
using namespace std;

string str[8] = {"c=","c-","dz=","d-","lj","nj","s=","z="};
bool visited[105];

int main()
{
    cin.tie(0); cout.tie(0);
    ios::sync_with_stdio(0);

    string s; cin >> s;

    // 1. visited를 활용한 풀이
    // int result = 0;
    // for (int i=0; i<8; ++i)
    // {
    //     int pos = 0;
    //     while ((pos = s.find(str[i], pos)) != string::npos)
    //     {
    //         bool isVisited = false;
    //         for (int j=0; j<str[i].size(); ++j)
    //         {
    //             if (visited[pos+j])
    //             {
    //                 isVisited = true;
    //                 break;
    //             }
    //             visited[pos+j] = true;
    //         }
    //         if (isVisited)
    //         {
    //             pos += 1;
    //             continue;
    //         }
    //         pos += str[i].size();
    //         result += 1;
    //     }
    // }

    // 2. 치환을 통한 풀이
    for (int i=0; i<8; ++i)
    {
        int pos = 0;
        while ((pos = s.find(str[i], pos)) != string::npos)
        {
            s.replace(pos, str[i].size(), "#");
            pos += 1;
        }
    }


    cout << s.size();
}