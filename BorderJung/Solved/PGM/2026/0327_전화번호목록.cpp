// PGM 전화번호목록
#include <string>
#include <vector>
#include <algorithm>

using namespace std;

bool solution(vector<string> phone_book) {
    bool answer = true;

    sort(phone_book.begin(), phone_book.end());
    for (int i=1; i<phone_book.size(); ++i) {
        string a = phone_book[i-1];
        string b = phone_book[i].substr(0, a.size());
        if (a == b) {
            answer = false;
            break;
        }
    }

    return answer;
}
