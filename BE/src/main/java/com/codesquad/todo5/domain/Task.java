package com.codesquad.todo5.domain;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.data.annotation.Id;

@Getter
@Setter
@NoArgsConstructor
public class Task {

  @Id
  private Long id;
  private String title;
  private String content;
  private boolean isDeleted;
  private int priority;

  private Task(String title, String content) {
    this.title = title;
    this.content = content;
    this.isDeleted = false;
  }

  public static Task create(String title, String content) {
    return new Task(title, content);
  }
}