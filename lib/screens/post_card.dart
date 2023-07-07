import 'package:coastal/provider/post_model.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {

  void initState() {
    super.initState();
    Provider.of<PostProvider>(context, listen: false).fetchPosts();
  }
  @override
  Widget build(BuildContext context) {
    @override
    final postProvider = Provider.of<PostProvider>(context, listen: false);

    final List<Post> posts = postProvider.posts;

    return ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return InkWell(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                                image: NetworkImage(posts[index].filenames),
                                fit: BoxFit.cover)),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            posts[index].time,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${posts[index].longitude} • ${posts[index]
                                .latitude} •${posts[index].time}',
                            style: const TextStyle(fontSize: 12, color: Colors
                                .grey),
                          )
                        ],
                      ),
                      const Spacer(),

                      const SizedBox(width: 5),
                      const Icon(Icons.more_vert)
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Text(widget.post.description),
                  const SizedBox(height: 5),
                  Hero(
                    tag: posts[index].pid,
                    child: Container(
                      height: 140,
                      width: double.maxFinite,
                      alignment: Alignment.topRight,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: NetworkImage(posts[index].filenames
                              ),
                              fit: BoxFit.cover)),
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.05),
                        ),
                        child: const Icon(
                            Icons.attachment, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                ],
              ),
            ),
          );
        }
    );
  }
}
