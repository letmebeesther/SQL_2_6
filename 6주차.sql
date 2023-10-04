begin try
	select 1/0 as 나누기
end try
begin catch
	select '오류 : 0으로 나누기를 시도하였습니다.'
end catch

begin try
	drop table 배화
end try
begin catch
	select '오류 : 없는 테이블을 삭제 시도하였습니다.'
end catch

begin try
	select 1/0 as 나누기
end try
begin catch
	select error_number() 오류번호,
			  error_line() [오류발생 줄번호], 
			  error_message() 오류메세지,
			  error_state() 오류상태,
			  error_severity() 오류심각도
end catch

exec sp_who

select nullif(2,3) -- 두개의 값이 다르면 앞쪽의 값을 리턴. 여기선 2
select nullif(3,3) -- 두개의 값이 같으면 null을 리턴.

select coalesce(null,1,2) -- null이 아닌 첫번째 값을 리턴
select coalesce(1,null,2)
select coalesce(null,null,1)

select * from 사원업무
select 이름, coalesce(시급,연봉,판매수량,커미션) from 사원업무

/*
사원들의 연봉 계산하기
시급 : 시급 * 40 * 52 (1년동안 일한 시간)
연봉 : 그대로
판매수량 : 판매수량 *11000
*/

select 이름, coalesce(시급*40*52,연봉,판매수량*11000,커미션) 연봉 from 사원업무

/*
뷰 : 실제 존재하는 테이블이 아니라 필요로 하는 칼럼만 모아서 가상으로 만든 테이블
*/

-- view 테이블 만들기
create view v1
as
select 이름, 성별 from 성적

select * from v1

/*
1.‘제품’ 테이블을 기반으로 제품번호, 제품명, 가격으로 이루어진 뷰 ‘제품_view1’를 생성하시오.
예) select 제품번호, 제품명, 가격
    from ‘제품 (뷰로 생성)
*/

create view 제품_view1
as
select 제품번호,제품명,가격 from 제품

select * from 제품_view1

create view v2
as
select 종류, avg(가격) 평균가격 from 제품 -- 열이름이 없으면 오류발생
group by 종류

select * from v2

select * from 제품
select * from 판매

create view 판매view
as
select 제품명, sum(판매수량) 판매수량
from 제품 join 판매
on 제품.제품번호=판매.판매번호
group by  제품명

select * from 판매view

--성적테이브롤 만든 뷰 v1,v0
create view v0
as
select 학번,이름,성별 from 성적

select * from v0
--201901099, 톰크루즈, 남
insert v0 values(202101099,'톰크루즈','남')

select*from 성적

select*from v1
insert v1 values('톰크루즈','남')--오류발생 : 맨처음에 성적테이블 만들때 학번에 중복과 널이 들어가면 안되는 primery key를 사용했기 때문

/*
4. 뷰(view) 입력 예제1
앞서 문제1에서 만든 뷰 ‘제품_view1’ 에 다음 
레코드를 입력해보고 입력 결과의 의미를 설명해보시오.
*/

insert 제품_view1 values(20,'원피스',48000)
select * from 제품_view1

/*
5. 뷰(view) 생성과 입력 예제
‘제품’ 테이블을 기반으로 제품명, 가격으로 이루어진 뷰 ‘제품_view2’를 생성하고 
아래 레코드를 입력하시오. 레코드 입력 결과의 의미를 설명해보시오.
예) select  제품명, 가격
    from  제품 (뷰로 생성)
*/

create view 제품_view2
as
select 제품명, 가격 from 제품

select * from 제품_view2

insert 제품_view2 values('바지',30000)--오류발생 : 제품번호에 null값을 삽입할 수 없음. primary key 제약

alter view v1
as
select 이름, 성별, 점수 from 성적

drop view v1

select * into 제품1 from 제품 --제품1만 활용
select * from 제품1

create view v3
as
select 제품번호, 제품명, 가격 from 제품1

alter view v3
as
select 제품번호, 제품명, 가격 from 제품1
where 가격>=80000 -- 8만원 이상

update v3 set 가격 = 50000 where 제품번호=9
select * from 제품1--제품번호 9번 가격 50000원으로 수정됨
select*from v3 --뷰에서는 못봄
--뷰의 조건과 맞지 않게 수정되면 뷰에선 안보이지만 원본에 수정결과 확인가능

alter view v3 
with encryption -- sp_helptext 사용하지 못하게 막아줌. 암호화시킴
as
select 제품번호, 제품명, 가격 from 제품1
where 가격>=80000 -- 8만원 이상
with check option -- 뷰 설정 조건에 맞지 않게 수정X

select * from v3

sp_helptext v3 -- 어떻게 만들었는지 뷰에 대한 구문을 볼 수 있음