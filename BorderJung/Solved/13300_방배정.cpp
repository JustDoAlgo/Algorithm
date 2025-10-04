#include <iostream>
#include <vector>
using namespace std;

/*
1. 남녀 분리
2. 같은 방은 같은 학년끼리
학년과 성별을 저장하고 개수를 불러와야 해.
vector<vector<int>> students; 
- students[1][0]: 1학년 여학생
- students[6][1]: 6학년 남학생
*/
int main()
{
    cin.tie(0);
    ios::sync_with_stdio(false);

    int N, K;
    cin >> N >> K;
    vector<vector<int>> students(7, vector<int>(2, 0));
    
    int grade, sex;
    while (N--)
    {
        cin >> sex >> grade;
        students[grade][sex] += 1;
    }

    int result = 0;
    for (int grade=1; grade<=6; ++grade)
    {
        for (int sex=0; sex<2; ++sex)
        {
            result += (students[grade][sex] + K - 1) / K;
        }
    }
    cout << result;
}