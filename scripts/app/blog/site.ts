import { Process } from '@yao/yao';
/**
 * blog sui pages callback functions,used in blog sui pages
 */

/**
 * 根据文章ID获取文章内容
 * yao run scripts.app.blog.site.getPost
 * @param post_id - 文章ID
 * @returns 文章对象，如果文章不存在则返回默认的“未找到”对象
 */
export function getPost(post_id: number) {
  const [b] = Process('models.app.blog.post.get', {
    wheres: [
      {
        column: 'id',
        value: post_id
      },
      {
        column: 'status',
        value: true
      }
    ]
  });
  if (b != null) {
    if (b.img == null) {
      b.img = '';
    }
    return b;
  } else {
    return { title: 'Not Found', content: `<div>Post Not Found</div>` };
  }
}

/**
 * 获取文章列表
 * yao run scripts.app.blog.site.getPostList
 * @returns 包含文章列表的对象
 */
export function getPostList() {
  // 使用 Process 函数从数据库中获取文章列表，选择特定字段并筛选状态为 true 的文章
  const list = Process('models.app.blog.post.get', {
    select: ['title', 'id', 'post_type', 'img', 'description'],
    wheres: [
      {
        column: 'status',
        value: true
      }
    ]
  });
  // 遍历文章列表，为每篇文章添加 url 字段
  list.forEach((item) => {
    // 如果文章的图片字段为空，则设置为空字符串
    if (!item.img) {
      item.img = '';
    }
    // 为文章添加 url 字段，指向文章详情页
    item.url = `/blog/article.sui?post_id=` + item.id;
  });
  // 返回包含文章列表的对象
  return { data: list };
}
