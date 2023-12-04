# 密码加密原则

#### 密码为什么需要加密

如果未加密，将密码的原文（原始密码）直接存入到数据库中，可以被轻松获取账户的关键信息！

以目前主流的网络结构和技术，通常，密码加密主要防范的是内部工作人员（能够接触到服务器的人员）！

需要注意：即使密码加密了，也要防范相关的内部工作人员，例如程序员！

#### 如何对密码进行加密

直接使用现有的某种算法，也就是说，不会自行设计某个算法！

#### 使用什么算法对密码进行加密

一定**不可以**使用**加密算法**！因为所有加密算法都是可以被逆向运算的，也就是说，可以根据加密得到的结果，进行反向运算，还原出原始密码！通常，加密算法仅用于保障数据在传输过程中的安全！

在对密码进行加密处理并存入到数据库中时，应该使用**不可逆**的算法！许多**哈希算法**，或基于哈希算法的**消息摘要算法**都是不可逆的！

#### 关于消息摘要算法

典型的消息摘要算法有：

- SHA（Secure Hash Algorithm）家族算法
  - SHA-1（160位算法）
  - SHA-256（256位算法）
  - SHA-384（384位算法）
  - SHA-512（512位算法）
- MD（Message Digest）系列算法
  - MD2（128位算法）
  - MD4（128位算法）
  - MD5（128位算法）

消息摘要算法原本是用于验证接收方所接收的数据与发送方所发出的数据是否一致。

消息摘要算法有几个典型特征：

- 如果消息相同，则摘要一定相同
- 如果消息不同，则摘要极大概率会不同
  - 必然存在n个不同的消息，摘要完全相同
- 使用同一种算法时，无论消息长度是多少，摘要的长度是固定的

#### 在项目中使用MD5算法

在Spring框架中，提供了`DigestUtils`，可以非常便利的使用MD5算法将消息处理为摘要：

```java
public class Md5Tests {

    @Test
    void encode() {
        String rawPassword = "123456";
        String encodedPassword = DigestUtils.md5DigestAsHex(
                rawPassword.getBytes());
        System.out.println("原文：" + rawPassword);
        System.out.println("密文：" + encodedPassword);
    }

}
```

#### 算法位数对安全性的影响

以MD5算法为例，它是128位的算法，即其运算结果是由128个二进制位组成的，所以，其运算结果的排列组件有2的128次方种，这个数字转换成十进制是：340282366920938463463374607431768211456。

理论上，使用MD5算法时，要想找到2个不同的消息运算出相同的摘要，概率应该是340282366920938463463374607431768211456分之1！或者，也可以认为，你至少需要运算340282366920938463463374607431768211456次，才可以找到2个不同的消息运算出相同的摘要。

相比之下，更高位数的算法，理论上，更难找出不同的消息运算出相同的摘要！

一般情况下，由于MD5的安全系数已经较高，所以，不一定需要使用位数更高的算法！

#### 关于消息算法的破解 -- 学术

当2个不同的消息，运算出相同的摘要，从学术上，称之为“碰撞”。

理论上，128位的算法，其碰撞概率应该是2的128次方分之1。

关于消息算法的破解，主要是研究其碰撞概率，是否可以使用更少次数的运算实现碰撞！而不是尝试根据摘要进行逆向运算还原出消息！

目前，SHA-1算法已经被视为不安全的算法，它是160位算法，经过研究，只需要经过2的60几次方的运算就可以发生碰撞，即SHA-1的安全系数与60几位的算法几乎相当。

#### 关于消息算法的“破解” -- 根据摘要得到消息

做法：网上有许多平台可以做到“根据密文还原出原文”。

 
