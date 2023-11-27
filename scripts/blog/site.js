//yao run scripts.blog.site.getPost
function getPost(post_id) {


    const [b] = Process("models.blog.post.get", {
        wheres: [
            {
                column: 'id',
                value: post_id
            }
        ]
    })
    if (b != null) {
        return { title: b.title, content: b.content }
    } else {
        return { title: 'Not Found', content: `<div>Post Not Found</div>` }
    }
}

// yao run scripts.blog.site.getPostList
function getPostList() {
    const list = Process("models.blog.post.get", {
        select: ['title', 'id', 'post_type', 'img', 'description']
    })
    list.forEach(item => {
        if (!item.img) {
            item.img = ""
        }
        item.url = `/blog/article.sui?post_id=` + item.id
    });

    return { data: list }
}