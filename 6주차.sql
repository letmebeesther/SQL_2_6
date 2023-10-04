begin try
	select 1/0 as ������
end try
begin catch
	select '���� : 0���� �����⸦ �õ��Ͽ����ϴ�.'
end catch

begin try
	drop table ��ȭ
end try
begin catch
	select '���� : ���� ���̺��� ���� �õ��Ͽ����ϴ�.'
end catch

begin try
	select 1/0 as ������
end try
begin catch
	select error_number() ������ȣ,
			  error_line() [�����߻� �ٹ�ȣ], 
			  error_message() �����޼���,
			  error_state() ��������,
			  error_severity() �����ɰ���
end catch

exec sp_who

select nullif(2,3) -- �ΰ��� ���� �ٸ��� ������ ���� ����. ���⼱ 2
select nullif(3,3) -- �ΰ��� ���� ������ null�� ����.

select coalesce(null,1,2) -- null�� �ƴ� ù��° ���� ����
select coalesce(1,null,2)
select coalesce(null,null,1)

select * from �������
select �̸�, coalesce(�ñ�,����,�Ǹż���,Ŀ�̼�) from �������

/*
������� ���� ����ϱ�
�ñ� : �ñ� * 40 * 52 (1�⵿�� ���� �ð�)
���� : �״��
�Ǹż��� : �Ǹż��� *11000
*/

select �̸�, coalesce(�ñ�*40*52,����,�Ǹż���*11000,Ŀ�̼�) ���� from �������

/*
�� : ���� �����ϴ� ���̺��� �ƴ϶� �ʿ�� �ϴ� Į���� ��Ƽ� �������� ���� ���̺�
*/

-- view ���̺� �����
create view v1
as
select �̸�, ���� from ����

select * from v1

/*
1.����ǰ�� ���̺��� ������� ��ǰ��ȣ, ��ǰ��, �������� �̷���� �� ����ǰ_view1���� �����Ͻÿ�.
��) select ��ǰ��ȣ, ��ǰ��, ����
    from ����ǰ (��� ����)
*/

create view ��ǰ_view1
as
select ��ǰ��ȣ,��ǰ��,���� from ��ǰ

select * from ��ǰ_view1

create view v2
as
select ����, avg(����) ��հ��� from ��ǰ -- ���̸��� ������ �����߻�
group by ����

select * from v2

select * from ��ǰ
select * from �Ǹ�

create view �Ǹ�view
as
select ��ǰ��, sum(�Ǹż���) �Ǹż���
from ��ǰ join �Ǹ�
on ��ǰ.��ǰ��ȣ=�Ǹ�.�ǸŹ�ȣ
group by  ��ǰ��

select * from �Ǹ�view

--�������̺�� ���� �� v1,v0
create view v0
as
select �й�,�̸�,���� from ����

select * from v0
--201901099, ��ũ����, ��
insert v0 values(202101099,'��ũ����','��')

select*from ����

select*from v1
insert v1 values('��ũ����','��')--�����߻� : ��ó���� �������̺� ���鶧 �й��� �ߺ��� ���� ���� �ȵǴ� primery key�� ����߱� ����

/*
4. ��(view) �Է� ����1
�ռ� ����1���� ���� �� ����ǰ_view1�� �� ���� 
���ڵ带 �Է��غ��� �Է� ����� �ǹ̸� �����غ��ÿ�.
*/

insert ��ǰ_view1 values(20,'���ǽ�',48000)
select * from ��ǰ_view1

/*
5. ��(view) ������ �Է� ����
����ǰ�� ���̺��� ������� ��ǰ��, �������� �̷���� �� ����ǰ_view2���� �����ϰ� 
�Ʒ� ���ڵ带 �Է��Ͻÿ�. ���ڵ� �Է� ����� �ǹ̸� �����غ��ÿ�.
��) select  ��ǰ��, ����
    from  ��ǰ (��� ����)
*/

create view ��ǰ_view2
as
select ��ǰ��, ���� from ��ǰ

select * from ��ǰ_view2

insert ��ǰ_view2 values('����',30000)--�����߻� : ��ǰ��ȣ�� null���� ������ �� ����. primary key ����

alter view v1
as
select �̸�, ����, ���� from ����

drop view v1

select * into ��ǰ1 from ��ǰ --��ǰ1�� Ȱ��
select * from ��ǰ1

create view v3
as
select ��ǰ��ȣ, ��ǰ��, ���� from ��ǰ1

alter view v3
as
select ��ǰ��ȣ, ��ǰ��, ���� from ��ǰ1
where ����>=80000 -- 8���� �̻�

update v3 set ���� = 50000 where ��ǰ��ȣ=9
select * from ��ǰ1--��ǰ��ȣ 9�� ���� 50000������ ������
select*from v3 --�信���� ����
--���� ���ǰ� ���� �ʰ� �����Ǹ� �信�� �Ⱥ������� ������ ������� Ȯ�ΰ���

alter view v3 
with encryption -- sp_helptext ������� ���ϰ� ������. ��ȣȭ��Ŵ
as
select ��ǰ��ȣ, ��ǰ��, ���� from ��ǰ1
where ����>=80000 -- 8���� �̻�
with check option -- �� ���� ���ǿ� ���� �ʰ� ����X

select * from v3

sp_helptext v3 -- ��� ��������� �信 ���� ������ �� �� ����