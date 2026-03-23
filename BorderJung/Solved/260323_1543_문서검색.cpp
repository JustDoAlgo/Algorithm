/*
1543 문서 탐색
26.03.23 20:45~25.50
메모
### getline()

만약 인자로 char* 이 들어온다면? char* -> string 전환도 알아두자
- getline(cin, a); // a는 미리 선언한 string
- string s = cstr; // char* cstr; 을 그냥 바로 대입하면 된다.
- string s(cstr);  // 생성자에 넣기도 가능

### string::find

특정 문자열을 찾는 메서드
- str.find(subStr, pos); // 이때 pos는 int형. 찾은 문자열의 첫 index 반환.
*/

#include <iostream>
#include <string>
using namespace std;

int main()
{
    cin.tie(0); cout.tie(0);
    ios::sync_with_stdio(0);

    string a, b;
    getline(cin, a);
    getline(cin, b);
    int result = 0;
    // 1. 분기 별로 구현
    // for (int i=0; i<a.size(); ++i)
    // {
    //     if (a[i] == b[0])
    //     {
    //         bool isFound = true;
    //         for (int j=0; j<b.size(); ++j)
    //         {
    //             if (a[i+j] != b[j])
    //             {
    //                 isFound = false;
    //                 break;
    //             }
    //         }
    //         if (isFound)
    //         {
    //             result += 1;
    //             i = i + b.size() - 1;
    //         }
    //     }
    // }
    // 2. find 메서드 사용
    int pos = 0;
    while ((pos = a.find(b, pos)) != string::npos)
    {
        result += 1;
        pos += b.size(); // 만약 중복 허용이면, 여기서 1만 더해주면 된다.
    }

    cout << result;
}