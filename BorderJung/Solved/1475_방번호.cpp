#include <iostream>
#include <vector>
using namespace std;

/*
숫자 개수의 최댓값 만큼 필요하다.
6과 9는 공유가 되니 6의 개수 + 9의 개수로 처리하고
나머지 숫자는 단일 숫자의 개수로 처리

만약 1269 이면 한 세트 면 되고
만약 1266 이여도 한 세트면 된다.
만약 6669 이면 2세트면 된다. 6의 개수 3, 9의 개수 1 이지만 6 1개를 9로 대체하면 되니
결론적으로 6과 9는 특별 대우로 (둘의 개수의 합 / 2)가 필요한 최소 세트가 된다.
*/
int main()
{
    string num;
    cin >> num;

    vector<int> counts(10, 0);
    for (auto& e : num)
    {
        int currentNum = e - '0';
        counts[currentNum] += 1;
    }

    int result = (counts[6] + counts[9] + 1) / 2;
    for (int i=0; i<10; ++i)
    {
        if (i != 6 && i != 9)
        {
            result = max(result, counts[i]);
        }
    }

    cout << result;
}