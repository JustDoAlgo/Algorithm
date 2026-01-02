import java.util.*;

class Solution {
    public String solution(String[] cards1, String[] cards2, String[] goal) {
        // cards1,2,goal queue에 넣기
        // goal의 한 단어씩 LOOP
        // cards1, cards2 중 한곳에 매칭되는 단어가 있다면 goal, 덱 poll
        // 없다면 result="No"
        
        ArrayDeque<String> c1 = new ArrayDeque<>(Arrays.asList(cards1));
        ArrayDeque<String> c2 = new ArrayDeque<>(Arrays.asList(cards2));
        ArrayDeque<String> g = new ArrayDeque<>(Arrays.asList(goal));

        
        while(!g.isEmpty()){
            String targetVoca = g.peek();

            if(!c1.isEmpty()&&c1.peek() == targetVoca){
                g.pollFirst();
                c1.pollFirst();
            }
            else if (!c2.isEmpty()&&c2.peek() == targetVoca){
                g.pollFirst();
                c2.pollFirst();
            }

            else{
                return "No";
            }
        }


        return "Yes";
    }
}