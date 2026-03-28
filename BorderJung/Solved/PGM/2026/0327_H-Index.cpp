// PGM H-Index
#include <string>
#include <vector>
#include <algorithm>

using namespace std;

int solution(vector<int> c) {
    int answer = 0;

    sort(c.begin(), c.end());
    int n = c.size();
    for (int i=0; i<n; ++i) {
        if (n - i <= c[i])
        {
            answer = min(c[i], n - i);
            break;
        }
    }

    return answer;
}
